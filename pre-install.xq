xquery version "3.1";

(:~
 : Pre-install script.
 :
 : Creates system config collections for index configurations.
 : The actual xconf files are installed in finish.xq (post-install)
 : because $dir may not be accessible via doc() during pre-install.
 :)

(: External variables set by the package manager :)
declare variable $home external;
declare variable $dir external;
declare variable $target external;

declare function local:mkcol-recursive($collection as xs:string, $components as xs:string*) {
    if (empty($components)) then
        ()
    else
        let $child := head($components)
        let $new-coll := $collection || "/" || $child
        return (
            if (xmldb:collection-available($new-coll)) then
                ()
            else
                xmldb:create-collection($collection, $child),
            local:mkcol-recursive($new-coll, tail($components))
        )
};

(: Pre-create the system config paths so finish.xq can store xconf files :)
let $sys-config := "/db/system/config" || $target
let $_ := local:mkcol-recursive("/db/system/config",
    tokenize(substring-after($sys-config || "/data/functions", "/db/system/config/"), "/")[. != ""]
)
let $_ := local:mkcol-recursive("/db/system/config",
    tokenize(substring-after($sys-config || "/data/articles", "/db/system/config/"), "/")[. != ""]
)

(: Pre-create system config paths for try-it sample data collections.
 : Reads the registry.xml from the XAR source ($dir) to discover which
 : module directories may contain collection.xconf files, and creates
 : the corresponding /db/system/config/... paths. :)
let $registry :=
    if (doc-available($dir || "/data/try-it/registry.xml")) then
        doc($dir || "/data/try-it/registry.xml")/try-it-registry
    else ()
let $_ :=
    if (exists($registry)) then
        for $module in $registry/module
        let $module-dir := $module/@dir/string()
        let $sys-path := $sys-config || "/data/try-it/" || $module-dir || "/data"
        return
            local:mkcol-recursive("/db/system/config",
                tokenize(substring-after($sys-path, "/db/system/config/"), "/")[. != ""]
            )
    else ()

return
    util:log("INFO", "documentation-next: system config collections created")
