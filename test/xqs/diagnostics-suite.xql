xquery version "3.1";

(:~
 : Link and resource diagnostics tests.
 :
 : Adapted from the old documentation app's diagnostics.xql.
 : Checks all xlink:href and fileref attributes in DocBook articles
 : for dead links, orphaned resources, and broken anchors.
 :)
module namespace diag = "http://exist-db.org/apps/docs/diagnostics";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "../../modules/config.xqm";

declare namespace test = "http://exist-db.org/xquery/xqsuite";
declare namespace db = "http://docbook.org/ns/docbook";
declare namespace xlink = "http://www.w3.org/1999/xlink";

declare variable $diag:articles-root := $config:data-root || "/articles";

(: ─── Link classification ──────────────────────────────────────────── :)

declare %private function diag:link-type($link as xs:string) as xs:string {
    let $no-anchor :=
        if (contains($link, '#')) then substring-before($link, '#')
        else $link
    return
        if (starts-with($link, '/')) then "unknown"
        else if (contains($link, '{')) then "computed"
        else if (matches($link, '^https?://|^mailto:')) then "external"
        else if (contains($no-anchor, '/')) then "resource"
        else if (ends-with($link, '.xml') or not(contains($link, '.'))) then "article"
        else "unknown"
};

declare %private function diag:link-no-anchor($link as xs:string) as xs:string {
    if (contains($link, '#')) then substring-before($link, '#')
    else $link
};

declare %private function diag:link-anchor($link as xs:string) as xs:string {
    if (contains($link, '#')) then substring-after($link, '#')
    else ''
};

(: ─── Article link resolution ──────────────────────────────────────── :)

(:~
 : Resolve an article link to a collection path.
 : Articles are referenced by slug (directory name), optionally with .xml.
 :)
declare %private function diag:resolve-article($slug as xs:string) as xs:string? {
    let $clean := replace($slug, '\.xml$', '')
    let $path := $diag:articles-root || "/" || $clean
    return
        if (xmldb:collection-available($path)) then $path
        else ()
};

(: ─── Dead link detection ──────────────────────────────────────────── :)

(:~
 : Find all broken inter-article links.
 : An article link like xlink:href="basic-installation" should resolve
 : to data/articles/basic-installation/.
 :)
declare
    %test:name("No broken article cross-references")
    %test:assertEmpty
function diag:broken-article-links() {
    for $doc in collection($diag:articles-root)/db:article
    let $doc-uri := document-uri(root($doc))
    let $doc-name := replace($doc-uri, '^.*/articles/([^/]+)/.*$', '$1')
    for $link in distinct-values($doc//@xlink:href/string())
    let $type := diag:link-type($link)
    where $type = "article"
    let $target-slug := diag:link-no-anchor($link)
    let $anchor := diag:link-anchor($link)
    let $resolved := diag:resolve-article($target-slug)
    return
        if (empty($resolved) and $target-slug != "") then
            $doc-name || ": broken article link '" || $link || "'"
        else if ($anchor != "" and exists($resolved)) then
            let $target-doc := collection($resolved)/db:article
            return
                if (not($anchor = $target-doc//@xml:id/string())) then
                    $doc-name || ": broken anchor '" || $anchor ||
                    "' in article '" || $target-slug || "'"
                else ()
        else ()
};

(:~
 : Find all broken resource links (listings, assets).
 : A resource link like xlink:href="listings/listing-1.txt" should
 : resolve relative to the article's collection.
 :)
declare
    %test:name("No broken resource links")
    %test:assertEmpty
function diag:broken-resource-links() {
    for $doc in collection($diag:articles-root)/db:article
    let $doc-uri := document-uri(root($doc))
    let $doc-collection := util:collection-name(root($doc))
    let $doc-name := replace($doc-uri, '^.*/articles/([^/]+)/.*$', '$1')
    for $link in distinct-values($doc//@xlink:href/string())
    let $type := diag:link-type($link)
    where $type = "resource"
    let $full-path := $doc-collection || "/" || $link
    let $path-part := replace($link, '/[^/]+$', '')
    let $name-part := tokenize($link, '/')[last()]
    let $full-collection := $doc-collection || "/" || $path-part
    return
        if (not(xmldb:collection-available($full-collection))) then
            $doc-name || ": missing collection for '" || $link || "'"
        else if (not($name-part = xmldb:get-child-resources($full-collection))) then
            $doc-name || ": missing resource '" || $link || "'"
        else ()
};

(:~
 : Find all broken image fileref attributes.
 : An imagedata fileref="assets/screenshot.png" should resolve
 : relative to the article's collection.
 :)
declare
    %test:name("No broken image references")
    %test:assertEmpty
function diag:broken-image-refs() {
    for $doc in collection($diag:articles-root)/db:article
    let $doc-uri := document-uri(root($doc))
    let $doc-collection := util:collection-name(root($doc))
    let $doc-name := replace($doc-uri, '^.*/articles/([^/]+)/.*$', '$1')
    for $fileref in distinct-values($doc//@fileref/string())
    let $path-part := replace($fileref, '/[^/]+$', '')
    let $name-part := tokenize($fileref, '/')[last()]
    let $full-collection := $doc-collection || "/" || $path-part
    return
        if (not(xmldb:collection-available($full-collection))) then
            $doc-name || ": missing collection for image '" || $fileref || "'"
        else if (not($name-part = xmldb:get-child-resources($full-collection))) then
            $doc-name || ": missing image '" || $fileref || "'"
        else ()
};

(: ─── Orphaned resources ───────────────────────────────────────────── :)

(:~
 : Find resources (listings, assets) that exist on disk but are not
 : referenced by any article.
 :)
declare
    %test:name("No orphaned resources")
    %test:assertEmpty
function diag:orphaned-resources() {
    for $doc in collection($diag:articles-root)/db:article
    let $doc-collection := util:collection-name(root($doc))
    let $doc-name := replace(document-uri(root($doc)), '^.*/articles/([^/]+)/.*$', '$1')
    let $all-refs := distinct-values((
        $doc//@xlink:href/string(),
        $doc//@fileref/string()
    ))
    for $sub in xmldb:get-child-collections($doc-collection)
    for $resource in xmldb:get-child-resources($doc-collection || "/" || $sub)
    let $rel-path := $sub || "/" || $resource
    where not($rel-path = $all-refs)
    return
        $doc-name || ": orphaned resource '" || $rel-path || "'"
};

(: ─── Content quality checks ──────────────────────────────────────── :)

(:~
 : XML programlistings should use external files (xlink:href),
 : not inline CDATA. Short inline snippets use <tag> or <code>.
 :)
declare
    %test:name("XML programlistings use external files")
    %test:assertEmpty
function diag:inline-xml-listings() {
    for $listing in collection($diag:articles-root)
        //db:programlisting[@language = 'xml']
    where normalize-space($listing) != '' and empty($listing/@xlink:href)
    let $doc-name := replace(
        document-uri(root($listing)), '^.*/articles/([^/]+)/.*$', '$1'
    )
    let $title := $listing/ancestor::db:article/db:info/db:title/string()
    return
        $doc-name || " (" || $title || "): inline XML in programlisting — use xlink:href"
};
