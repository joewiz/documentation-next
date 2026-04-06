xquery version "3.1";

(:~
 : Database collection/resource utility functions.
 :
 : Ported from fundocs dbutil.xqm for stored module scanning.
 :)
module namespace dbutil = "http://exist-db.org/apps/docs/dbutil";

(:~
 : Recursively scan a collection tree, applying a function to each collection.
 :)
declare function dbutil:scan-collections(
    $root as xs:anyURI,
    $func as function(xs:anyURI) as item()*
) {
    $func($root),
    if (sm:has-access($root, "rx")) then
        for $child in xmldb:get-child-collections($root)
        return
            dbutil:scan-collections(xs:anyURI($root || "/" || $child), $func)
    else
        ()
};

(:~
 : Scan all resources in a collection tree, applying a function to each
 : (collection, resource) pair.
 :)
declare function dbutil:scan(
    $root as xs:anyURI,
    $func as function(xs:anyURI, xs:anyURI?) as item()*
) {
    dbutil:scan-collections($root, function($collection as xs:anyURI) {
        $func($collection, ()),
        for $child in xmldb:get-child-resources($collection)
        where sm:has-access($collection, "rx")
        return
            $func($collection, xs:anyURI($collection || "/" || $child))
    })
};

(:~
 : Find all resources matching a MIME type in a collection tree.
 :)
declare function dbutil:find-by-mimetype(
    $collection as xs:anyURI,
    $mimeType as xs:string+
) {
    dbutil:scan($collection, function($collection, $resource) {
        if (exists($resource) and xmldb:get-mime-type($resource) = $mimeType) then
            $resource
        else
            ()
    })
};
