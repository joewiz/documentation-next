xquery version "3.1";

(:~
 : REST endpoint for loading/saving XDITA article content in the editor.
 :
 : GET  /api/articles/{slug}/xdita  — returns raw XDITA XML
 : PUT  /api/articles/{slug}/xdita  — saves XDITA XML from request body
 :)

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

declare variable $slug := request:get-attribute("$slug");

if (request:get-method() = "GET") then (
    response:set-header("Content-Type", "application/xml"),
    let $collection := $config:data-root || "/articles/" || $slug
    (: Prefer .xdita.xml (converted/edited), fall back to .xml :)
    let $xdita-path := $collection || "/" || $slug || ".xdita.xml"
    let $xml-path := $collection || "/" || $slug || ".xml"
    let $xdita :=
        if (doc-available($xdita-path)) then doc($xdita-path)/topic
        else if (doc-available($xml-path)) then doc($xml-path)/topic
        else ()
    return
        if (exists($xdita)) then
            $xdita
        else (
            response:set-status-code(404),
            <error>No XDITA article found for slug: { $slug }</error>
        )
)
else if (request:get-method() = "PUT") then (
    response:set-header("Content-Type", "application/json"),
    let $body := request:get-data()
    let $root := if ($body instance of document-node()) then $body/* else $body
    let $result :=
        try {
            if (local-name($root) = "topic") then
                let $collection := $config:data-root || "/articles/" || $slug
                let $filename := $slug || ".xdita.xml"
                let $_ := xmldb:store($collection, $filename, $root)
                return map { "status": "ok", "slug": $slug }
            else
                map { "status": "error", "message": "Root element must be 'topic'" }
        } catch * {
            map { "status": "error", "message": $err:description }
        }
    return serialize($result, map { "method": "json" })
)
else (
    response:set-status-code(405),
    response:set-header("Content-Type", "application/json"),
    serialize(map { "status": "error", "message": "Method not allowed" }, map { "method": "json" })
)
