xquery version "3.1";

(:~
 : Validate all try-it .xq files by executing them against eXist-db.
 : Reports errors, successes, and a summary.
 :
 : Run via: curl -s -u admin: http://localhost:8080/exist/rest/db/apps/docs/validate-tryit.xq
 :)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:media-type "text/plain";

declare function local:list-xq($path as xs:string) as xs:string* {
    (
        for $r in xmldb:get-child-resources($path)
        where ends-with($r, ".xq")
        return $path || "/" || $r,
        for $c in xmldb:get-child-collections($path)
        return local:list-xq($path || "/" || $c)
    )
};

let $tryit-root := "/db/apps/docs/data/try-it"
let $prefixes := ("fn", "array", "map", "math", "ft", "ngram")

let $results :=
    for $prefix in $prefixes
    let $dir := $tryit-root || "/" || $prefix
    where xmldb:collection-available($dir)
    for $path in local:list-xq($dir)
    let $rel := substring-after($path, $tryit-root || "/")
    let $query := unparsed-text($path)
    let $result :=
        try {
            let $_ := util:eval($query)
            return map { "status": "ok", "path": $rel }
        } catch * {
            map {
                "status": "error",
                "path": $rel,
                "code": $err:code,
                "message": $err:description
            }
        }
    return $result

let $errors := $results[?status = "error"]
let $ok := $results[?status = "ok"]

return string-join((
    "=== Try-it Validation Report ===",
    "",
    "Total: " || count($results) || " | OK: " || count($ok) || " | Errors: " || count($errors),
    "",
    if (exists($errors)) then (
        "=== ERRORS ===",
        for $e in $errors
        order by $e?path
        return $e?path || "  -->  " || $e?message
    ) else
        "All queries executed successfully!",
    ""
), "&#10;")
