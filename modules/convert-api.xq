xquery version "3.1";

(:~
 : REST endpoint for DocBook → XDITA article conversion.
 :
 : POST /api/articles/convert?slug={slug}  — convert one article
 : POST /api/articles/convert?slug=all     — convert all DocBook articles
 :
 : Stores converted XDITA as {slug}/{slug}.xdita.xml alongside the
 : original DocBook file during the transition period.
 :
 : Returns JSON: { "status": "ok"|"error", "converted": [...], "message": "..." }
 :)

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";
import module namespace convert = "http://exist-db.org/apps/docs/convert"
    at "convert-docbook.xqm";

declare namespace db = "http://docbook.org/ns/docbook";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

declare variable $slug := request:get-parameter("slug", ());

(:~
 : Convert a single article and store the result.
 :)
declare function local:convert-one($slug as xs:string) as map(*) {
    let $articles-root := $config:data-root || "/articles"
    let $collection := $articles-root || "/" || $slug
    (: Load the specific file by name to avoid picking up nested XML files :)
    let $doc-path := $collection || "/" || $slug || ".xml"
    let $article :=
        if (doc-available($doc-path)) then doc($doc-path)/db:article
        else ()
    return
        if (empty($article)) then
            map { "slug": $slug, "status": "skipped", "message": "No DocBook article found" }
        else
            try {
                let $xdita := convert:docbook-to-xdita($article, $slug)
                let $filename := $slug || ".xdita.xml"
                let $_ := xmldb:store($collection, $filename, $xdita)
                return
                    map { "slug": $slug, "status": "ok" }
            } catch * {
                map {
                    "slug": $slug,
                    "status": "error",
                    "message": $err:description
                }
            }
};

if (empty($slug)) then
    map { "status": "error", "message": "Missing 'slug' parameter" }
else if ($slug = "all") then
    let $articles-root := $config:data-root || "/articles"
    let $results :=
        for $article in collection($articles-root)/db:article
        let $doc-uri := document-uri(root($article))
        let $article-slug := tokenize(replace($doc-uri, "^.*/articles/", ""), "/")[1]
        return local:convert-one($article-slug)
    let $ok := count($results[?status = "ok"])
    let $errors := count($results[?status = "error"])
    return map {
        "status": if ($errors = 0) then "ok" else "partial",
        "converted": array { $results },
        "summary": $ok || " converted, " || $errors || " errors"
    }
else
    local:convert-one($slug)
