xquery version "3.1";

(:~
 : REST endpoint for loading/saving XDITA article content in the editor.
 :
 : GET  /api/articles/{slug}/xdita  — returns XDITA wrapped in a TEI envelope so
 :                                    jinn-tap's jt:import XQuery can find tei:body
 : PUT  /api/articles/{slug}/xdita  — receives jinn-tap's TEI export, unwraps back
 :                                    to XDITA, stores as .xdita.xml
 :
 : Why TEI envelope? jinn-tap's internal jt:import only searches $doc//tei:body
 : (namespace http://www.tei-c.org/ns/1.0). XDITA <body> has no namespace, so
 : jinn-tap can never find the content without wrapping it first.
 : On export, jinn-tap returns element names with "tei-" prefix in TEI namespace
 : (e.g. <tei:tei-section>). We strip the prefix and namespace to recover XDITA.
 :)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option output:method "text";
declare option output:media-type "application/xml";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

declare variable $slug := request:get-attribute("$slug");

(:~
 : Recursively copy XDITA nodes into TEI namespace (preserving local names).
 : Pre elements get xml:space="preserve" to prevent the XML serializer from
 : normalizing their whitespace (newlines → spaces) when indent mode is active.
 :)
declare function local:to-tei($nodes as node()*) as node()* {
    for $n in $nodes return typeswitch($n)
        case element() return
            element { QName("http://www.tei-c.org/ns/1.0", local-name($n)) } {
                $n/@*,
                if (local-name($n) = "pre") then (
                    attribute xml:space { "preserve" },
                    $n/node()   (: text content only — no recursion needed :)
                ) else
                    local:to-tei($n/node())
            }
        default return $n
};

(:~
 : Recursively strip TEI namespace from jinn-tap export.
 : jinn-tap exports body content with element names like "tei-section", "tei-p"
 : in the TEI namespace. Strip "tei-" prefix to recover XDITA element names.
 :)
declare function local:from-tei($nodes as node()*) as node()* {
    for $n in $nodes return typeswitch($n)
        case element() return
            let $local := local-name($n)
            (: Strip "tei-" prefix added by jinn-tap's export :)
            let $xdita-name :=
                if (starts-with($local, "tei-")) then substring($local, 5)
                else $local
            return
                element { $xdita-name } {
                    $n/@*,
                    local:from-tei($n/node())
                }
        default return $n
};

(:~
 : Rebuild the XDITA body tree, restoring original <pre> content where jinn-tap
 : has stripped newlines (it converts \n → space on export).
 :
 : Strategy: for each <pre> in jinn-tap's output, find the corresponding original
 : <pre> by position. If normalize-space() of both match, the user did not edit the
 : code — restore the original (with proper newlines). If they differ, keep the
 : edited content (user intentionally changed it, whitespace loss is unavoidable).
 :
 : $orig-pres must come from the ORIGINAL .xml source (not a previously saved
 : .xdita.xml) so that we always compare against a clean baseline.
 :)
declare function local:restore-pres($nodes as node()*, $orig-pres as element()*, $pos as xs:integer) as node()* {
    let $result :=
        for $n in $nodes return typeswitch($n)
            case element() return
                if (local-name($n) = "pre") then
                    let $this-pos := $pos + count($n/preceding::pre) + 1
                    let $orig := $orig-pres[$this-pos]
                    return
                        if (exists($orig) and normalize-space($n) = normalize-space($orig)) then
                            element pre { $n/@*, $orig/node() }   (: restore newlines :)
                        else
                            $n   (: user edited it — keep as-is :)
                else
                    element { node-name($n) } {
                        $n/@*,
                        local:restore-pres($n/node(), $orig-pres, $pos)
                    }
            default return $n
    return $result
};

if (request:get-method() = "GET") then
    let $collection := $config:data-root || "/articles/" || $slug
    (: Prefer .xdita.xml (converted/edited), fall back to .xml :)
    let $xdita-path := $collection || "/" || $slug || ".xdita.xml"
    let $xml-path := $collection || "/" || $slug || ".xml"
    let $topic :=
        if (doc-available($xdita-path)) then doc($xdita-path)/topic
        else if (doc-available($xml-path)) then doc($xml-path)/topic
        else ()
    return
        if (exists($topic)) then
            (: Wrap XDITA body content in TEI envelope so jinn-tap jt:import finds tei:body :)
            (: Pre-bind strings BEFORE the XML constructor — inside <TEI xmlns="..."> the
               default namespace becomes TEI, so $topic/title would search for tei:title :)
            let $topic-title := string($topic/title)
            let $tei-body-content := local:to-tei($topic/body/node())
            let $tei-doc :=
                <TEI xmlns="http://www.tei-c.org/ns/1.0">
                    <teiHeader>
                        <fileDesc>
                            <titleStmt>
                                <title>{$topic-title}</title>
                            </titleStmt>
                        </fileDesc>
                    </teiHeader>
                    <text>
                        <body>{$tei-body-content}</body>
                    </text>
                    <standOff>
                        <listAnnotation/>
                    </standOff>
                </TEI>
            return
                serialize($tei-doc, map {
                    "method": "xml",
                    "indent": true(),
                    "omit-xml-declaration": false()
                })
        else (
            response:set-status-code(404),
            serialize(
                map { "status": "error", "message": "No XDITA article found for: " || $slug },
                map { "method": "json" }
            )
        )

else if (request:get-method() = "PUT") then
    let $body := request:get-data()
    let $root := if ($body instance of document-node()) then $body/* else $body
    let $result :=
        try {
            (: jinn-tap exports a full TEI document; extract body content and convert back to XDITA :)
            if (local-name($root) = "TEI" or local-name($root) = "tei") then
                let $tei-body-nodes := $root//tei:body/node()
                let $xdita-body-content := local:from-tei($tei-body-nodes)
                let $collection := $config:data-root || "/articles/" || $slug
                let $orig-path-xdita := $collection || "/" || $slug || ".xdita.xml"
                let $orig-path-xml  := $collection || "/" || $slug || ".xml"
                (: For title/prolog: prefer .xdita.xml (latest saved state) :)
                let $orig-topic :=
                    if (doc-available($orig-path-xdita)) then doc($orig-path-xdita)/topic
                    else if (doc-available($orig-path-xml)) then doc($orig-path-xml)/topic
                    else ()
                (: For pre restoration: ALWAYS use .xml (original, unmangled baseline) :)
                let $orig-xml-pres :=
                    if (doc-available($orig-path-xml)) then doc($orig-path-xml)//pre
                    else ()
                (: Restore newlines in <pre> elements that jinn-tap collapsed to spaces :)
                let $restored-body := local:restore-pres($xdita-body-content, $orig-xml-pres, 0)
                let $new-topic :=
                    <topic id="{($orig-topic/@id, $slug)[1]}">
                        {$orig-topic/title}
                        {$orig-topic/prolog}
                        <body>{$restored-body}</body>
                    </topic>
                let $filename := $slug || ".xdita.xml"
                let $_ := xmldb:store($collection, $filename, $new-topic)
                return map { "status": "ok", "slug": $slug }
            (: Legacy: accept plain topic element :)
            else if (local-name($root) = "topic") then
                let $collection := $config:data-root || "/articles/" || $slug
                let $filename := $slug || ".xdita.xml"
                let $_ := xmldb:store($collection, $filename, $root)
                return map { "status": "ok", "slug": $slug }
            else
                map { "status": "error", "message": "Root element must be 'TEI' or 'topic', got: " || local-name($root) }
        } catch * {
            map { "status": "error", "message": $err:description }
        }
    return serialize($result, map { "method": "json" })

else (
    response:set-status-code(405),
    serialize(
        map { "status": "error", "message": "Method not allowed" },
        map { "method": "json" }
    )
)
