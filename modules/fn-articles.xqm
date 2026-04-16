xquery version "3.1";

(:~
 : Function article module.
 :
 : Loads and renders markdown articles supplementing function documentation.
 : Articles live in data/fn-articles/{prefix}/{local-name}.md (all arities)
 : or data/fn-articles/{prefix}/{local-name}_{arity}.md (arity-specific).
 :
 : Markdown files may include YAML front matter with a "query" key whose
 : value pre-populates the "Try it" panel for that function.
 :)
module namespace fn-articles = "http://exist-db.org/apps/docs/fn-articles";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

declare namespace md = "http://exist-db.org/xquery/markdown";

declare variable $fn-articles:root := $config:data-root || "/fn-articles";

(:~ exist-markdown module namespace URI :)
declare variable $fn-articles:MD_NS := "http://exist-db.org/xquery/markdown";

(:~ exist-markdown Java class path :)
declare variable $fn-articles:MD_CLASS :=
    "java:org.exist.xquery.modules.markdown.MarkdownModule";

(: ========================= :)
(:  Public API               :)
(: ========================= :)

(:~
 : Find and return the article for a given function.
 : Checks arity-specific file ({prefix}/{name}_{arity}.md) before the
 : general file ({prefix}/{name}.md).
 :
 : @param $prefix  the module namespace prefix (e.g. "fn", "util")
 : @param $local-name  the function local name without prefix
 : @param $arity  the function arity, or empty sequence
 : @return map with keys "body" (markdown text), "html" (rendered nodes),
 :         "query" (optional try-it XQuery), or empty sequence if no article
 :)
declare function fn-articles:find(
    $prefix as xs:string,
    $local-name as xs:string,
    $arity as xs:integer?
) as map(*)? {
    let $dir := $fn-articles:root || "/" || $prefix || "/"
    let $arity-path :=
        if (exists($arity)) then
            $dir || $local-name || "_" || $arity || ".md"
        else ()
    let $general-path := $dir || $local-name || ".md"
    let $path :=
        if (exists($arity-path) and util:binary-doc-available($arity-path)) then
            $arity-path
        else if (util:binary-doc-available($general-path)) then
            $general-path
        else ()
    return
        if (exists($path)) then
            let $text := unparsed-text($path)
            let $parsed := fn-articles:parse-front-matter($text)
            let $html := fn-articles:render($parsed?body)
            return map:merge(($parsed, map { "html": $html }))
        else ()
};

(:~
 : True when any articles exist for the given namespace prefix.
 : Use as a fast guard before enriching all functions in a module listing.
 :)
declare function fn-articles:has-articles-for($prefix as xs:string) as xs:boolean {
    xmldb:collection-available($fn-articles:root || "/" || $prefix)
};

(: ========================= :)
(:  Markdown Rendering       :)
(: ========================= :)

(:~
 : Render a markdown string to a single HTML element.
 : Uses the exist-markdown module if available, otherwise returns a preformatted fallback.
 : Always returns a single element so the result can be safely stored in a map.
 :)
declare function fn-articles:render($markdown as xs:string) as element() {
    let $parse-fn := fn-articles:md-fn("parse")
    let $html-fn  := fn-articles:md-fn("to-html")
    let $text := replace($markdown, "\r\n?", "&#10;")
    let $nodes :=
        if (exists($parse-fn) and exists($html-fn)) then
            let $doc := $parse-fn($text)
            for $node in $doc/md:document/*
            let $partial := $html-fn($node)
            let $str := fn-articles:unescape-html(serialize($partial))
            return
                try { parse-xml-fragment($str) }
                catch * { $partial }
        else
            <div class="fn-article-raw"><pre>{ $text }</pre></div>
    return <div class="fn-article-content">{ $nodes }</div>
};

(: ========================= :)
(:  Front-matter Parsing     :)
(: ========================= :)

(:~
 : Parse YAML-style front matter from a markdown string.
 :
 : Supports:
 :   - "key: value" — simple string scalar
 :   - "key: |"     — literal block scalar (subsequent indented lines)
 :
 : Returns a map containing all parsed keys plus "body" (the content
 : after the closing ---).
 :)
declare %private function fn-articles:parse-front-matter(
    $text as xs:string
) as map(*) {
    let $lines := tokenize($text, "\n")
    return
        if (not(matches($lines[1], "^---\s*$"))) then
            map { "body": $text }
        else
            let $end-idx :=
                head(
                    for $i in 2 to count($lines)
                    where matches($lines[$i], "^---\s*$")
                    return $i
                )
            let $yaml-lines :=
                if (exists($end-idx)) then
                    subsequence($lines, 2, $end-idx - 2)
                else ()
            let $body :=
                if (exists($end-idx)) then
                    string-join(subsequence($lines, $end-idx + 1), "&#10;")
                else $text
            let $meta := fn-articles:parse-yaml($yaml-lines)
            return map:merge(($meta, map { "body": $body }))
};

(:~
 : Parse a sequence of YAML key: value lines into a map.
 : Only processes top-level (unindented) keys.
 :)
declare %private function fn-articles:parse-yaml($lines as xs:string*) as map(*) {
    let $n := count($lines)
    return map:merge(
        for $i in 1 to $n
        let $line := $lines[$i]
        (: Only process top-level (unindented) key lines :)
        where matches($line, "^[A-Za-z][\w-]*\s*:")
        let $key      := normalize-space(replace($line, ":.*$", ""))
        let $val-part := normalize-space(replace($line, "^[^:]+:\s*", ""))
        return
            if ($val-part = "|") then
                (: Literal block scalar: collect subsequent indented lines :)
                let $block-end :=
                    head(
                        for $j in ($i + 1) to $n
                        where not(matches($lines[$j], "^\s")) and $lines[$j] != ""
                        return $j
                    )
                let $limit := ($block-end - 1, $n)[1]
                let $block-lines :=
                    for $j in ($i + 1) to $limit
                    return replace($lines[$j], "^  ", "") (: strip 2-space indent :)
                (: Trim leading/trailing blank lines from the block value :)
                return map:entry($key,
                    replace(string-join($block-lines, "&#10;"), "^[\s\n]+|[\s\n]+$", "")
                )
            else if ($val-part != "") then
                map:entry($key, $val-part)
            else ()
    )
};

(: ========================= :)
(:  Internal helpers         :)
(: ========================= :)

(:~ Dynamically import an exist-markdown function by name (arity 1). :)
declare %private function fn-articles:md-fn($name as xs:string) as function(*)? {
    try {
        util:import-module(
            xs:anyURI($fn-articles:MD_NS),
            "md",
            xs:anyURI($fn-articles:MD_CLASS)
        ),
        function-lookup(QName($fn-articles:MD_NS, $name), 1)
    } catch * { () }
};

(:~ Unescape HTML entities that exist-markdown over-escapes. :)
declare %private function fn-articles:unescape-html($html as xs:string) as xs:string {
    $html
    => replace("&amp;lt;", "&lt;")
    => replace("&amp;gt;", "&gt;")
    => replace("&amp;amp;", "&amp;")
};
