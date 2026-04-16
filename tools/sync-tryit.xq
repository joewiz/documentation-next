xquery version "3.1";

declare function local:sync-collection($db-path as xs:string, $fs-path as xs:string) {
    let $_ := if (file:exists($fs-path)) then () else file:create-dir($fs-path)
    let $synced-files :=
        for $resource in xmldb:get-child-resources($db-path)
        where ends-with($resource, ".xq")
        let $db-file := $db-path || "/" || $resource
        let $fs-file := $fs-path || "/" || $resource
        let $content := util:binary-to-string(util:binary-doc($db-file))
        return (
            file:write-text($fs-file, $content),
            $resource
        )
    let $synced-children :=
        for $child in xmldb:get-child-collections($db-path)
        return local:sync-collection($db-path || "/" || $child, $fs-path || "/" || $child)
    return ($synced-files, $synced-children)
};

for $prefix in ("fn", "array", "map", "math")
let $db := "/db/apps/docs/data/try-it/" || $prefix
let $fs := "/Users/wicentowskijc/workspace/documentation-next/data/try-it/" || $prefix
let $files := local:sync-collection($db, $fs)
return $prefix || ": " || count($files) || " files synced"
