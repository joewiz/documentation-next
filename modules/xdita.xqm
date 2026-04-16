xquery version "3.1";

(:~
 : XDITA article module.
 :
 : Handles loading, rendering (via compiled XDITA ODD), and table of contents
 : generation for Lightweight DITA (XDITA) topic documents.
 :
 : XDITA elements use no namespace (bare elements in default namespace).
 :)
module namespace xdita = "http://exist-db.org/apps/docs/xdita";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace pm-config = "http://www.tei-c.org/tei-simple/pm-config"
    at "pm-config.xql";
import module namespace site-config = "http://exist-db.org/site/shell-config"
    at "/db/apps/exist-site-shell/modules/site-config.xqm";

(: ========================= :)
(:  Article Loading          :)
(: ========================= :)

(:~
 : Load an XDITA topic article by slug.
 :
 : Looks for a <topic> root element (no namespace) in the article collection.
 :
 : @param $slug the article slug (directory name)
 : @return map with topic XML, metadata, and slug — or empty if not found
 :)
declare function xdita:load-article($slug as xs:string) as map(*)? {
    let $articles-root := $config:data-root || "/articles"
    let $collection := $articles-root || "/" || $slug
    return
        if (xmldb:collection-available($collection)) then
            (: Prefer .xdita.xml (edited) over .xml (original) :)
            let $xdita-path := $collection || "/" || $slug || ".xdita.xml"
            let $xml-path   := $collection || "/" || $slug || ".xml"
            let $topic :=
                if (doc-available($xdita-path)) then doc($xdita-path)/topic
                else if (doc-available($xml-path)) then doc($xml-path)/topic
                else ()
            return
                if (exists($topic)) then
                    map {
                        "slug": $slug,
                        "doc": $topic,
                        "format": "xdita",
                        "title": $topic/title/string(),
                        "date": $topic/prolog/data[@name = "date"]/@value/string(),
                        "keywords": array {
                            $topic/prolog/data[@name = "keyword"]/@value/string()
                        }
                    }
                else ()
        else ()
};

(: ========================= :)
(:  Rendering via ODD        :)
(: ========================= :)

(:~
 : Resolve cross-references in a single href string.
 : Handles both:
 :   {abbrev/path#fragment}  — whole href is a canonical reference
 :   {abbrev}/path           — legacy format: {abbrev} at start, path appended outside
 :)
declare %private function xdita:resolve-href($href as xs:string) as xs:string {
    if (matches($href, "^\{[^}]+\}$")) then
        site-config:resolve($href)
    else if (matches($href, "^\{[^}]+\}")) then
        let $ref    := replace($href, "^(\{[^}]+\}).*$", "$1")
        let $suffix := substring($href, string-length($ref) + 1)
        return site-config:resolve($ref) || $suffix
    else
        $href
};

(:~
 : Recursively copy an XDITA node tree, rewriting {abbrev[/path][#fragment]}
 : cross-references in @href attributes via site-config:resolve().
 :)
declare %private function xdita:resolve-refs($node as node()) as node() {
    typeswitch ($node)
        case element() return
            element { node-name($node) } {
                for $attr in $node/@*
                return
                    if (local-name($attr) = "href" and matches(string($attr), "^\{[^}]+\}")) then
                        attribute href { xdita:resolve-href(string($attr)) }
                    else
                        $attr,
                $node/node() ! xdita:resolve-refs(.)
            }
        default return $node
};

(:~
 : Render an XDITA topic to HTML using the compiled ODD transform.
 : Cross-references in the form {abbrev[/path][#fragment]} are resolved
 : to absolute URLs via site-config:resolve() before rendering.
 :
 : @param $topic the XDITA topic element
 : @return HTML fragment
 :)
declare function xdita:render($topic as element(topic)) as node()* {
    let $topic := xdita:resolve-refs($topic)
    return $pm-config:xdita-web-transform(map {
        "root": $topic,
        "webcomponents": 7
    }, $topic)
};

(: ========================= :)
(:  Table of Contents        :)
(: ========================= :)

(:~
 : Generate a table of contents from the XDITA section structure.
 :
 : XDITA sections are flat (no sect1/sect2 distinction), but can be
 : nested. We produce a two-level TOC from the section hierarchy.
 :
 : @param $topic the XDITA topic element
 : @return array of TOC entry maps with title, id, and children
 :)
declare function xdita:toc($topic as element(topic)) as array(*) {
    array {
        for $section in $topic/body/section
        let $id := ($section/@id/string(), generate-id($section))[1]
        return map {
            "title": $section/title/string(),
            "id": $id,
            "children": array {
                for $subsection in $section/section
                let $sub-id := ($subsection/@id/string(), generate-id($subsection))[1]
                return map {
                    "title": $subsection/title/string(),
                    "id": $sub-id
                }
            }
        }
    }
};

(: ========================= :)
(:  Search                   :)
(: ========================= :)

(:~
 : Search XDITA articles using Lucene full-text.
 :
 : @param $q the search query
 : @return array of result maps
 :)
declare function xdita:search($q as xs:string) as array(*) {
    if ($q = "") then
        array {}
    else
        (: Convert prefix:name patterns to phrase searches so that e.g. util:eval
           finds articles mentioning both "util" and "eval" adjacent to each other.
           The StandardAnalyzer splits on punctuation, so util:eval is indexed as
           two tokens; a phrase query "util eval" matches them when adjacent. :)
        let $escaped-q := replace($q, '(\w+):(\w+)', '"$1 $2"')
        let $articles-root := $config:data-root || "/articles"
        let $hits := collection($articles-root)//topic
            [ft:query(., $escaped-q, map { "fields": "site-content" })]
        return array {
            for $hit in $hits
            let $doc-uri := document-uri(root($hit))
            (: Skip plain .xml when a .xdita.xml (edited version) exists :)
            where not(
                ends-with($doc-uri, ".xml")
                and not(ends-with($doc-uri, ".xdita.xml"))
                and doc-available(replace($doc-uri, "\.xml$", ".xdita.xml"))
            )
            let $slug := xdita:uri-to-slug($doc-uri)
            let $title := $hit/title/string()
            order by ft:score($hit) descending
            return map {
                "slug": $slug,
                "title": $title,
                "description": substring(
                    string-join($hit/body/section[1]/p[1]//text(), " "), 1, 200
                ),
                "score": ft:score($hit),
                "type": "article"
            }
        }
};

(: ========================= :)
(:  Helpers                  :)
(: ========================= :)

(:~
 : Extract article slug from a database URI.
 :)
declare %private function xdita:uri-to-slug($uri as xs:string) as xs:string {
    let $parts := tokenize(replace($uri, "^.*/articles/", ""), "/")
    return $parts[1]
};
