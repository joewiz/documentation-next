xquery version "3.1";

(:~
 : Generate try-it .xq files for all functions in specified modules.
 : Run via: xst run tools/generate-tryit.xq
 :
 : Only creates files for functions that don't already have a try-it file.
 : Writes to data/try-it/{prefix}/{local-name}/{arity}/
 :)

import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "/db/apps/docs/modules/fundocs.xqm";
import module namespace tryit = "http://exist-db.org/apps/docs/try-it"
    at "/db/apps/docs/modules/try-it.xqm";

declare variable $local:prefixes := ("fn", "array", "map", "math");
declare variable $local:tryit-root := "/db/apps/docs/data/try-it";

(:~ Type-appropriate default values for XQuery/XSD types :)
declare function local:default-for-type($type as xs:string, $var-name as xs:string) as xs:string {
    let $t := normalize-space($type)
    let $base := replace($t, "[?*+]$", "")
    let $is-seq := ends-with($t, "*") or ends-with($t, "+")
    return
        switch ($base)
            case "xs:string"        return if ($is-seq) then '("hello", "world")' else '"hello"'
            case "xs:integer"       return if ($is-seq) then "(1, 2, 3)" else "42"
            case "xs:int"           return "42"
            case "xs:decimal"       return "3.14"
            case "xs:double"        return "2.718"
            case "xs:float"         return "1.5"
            case "xs:numeric"       return if ($is-seq) then "(10, 20, 30)" else "42"
            case "xs:boolean"       return "true()"
            case "xs:date"          return 'xs:date("2025-06-15")'
            case "xs:dateTime"      return "current-dateTime()"
            case "xs:time"          return 'xs:time("14:30:00")'
            case "xs:duration"      return 'xs:dayTimeDuration("P1DT2H")'
            case "xs:dayTimeDuration" return 'xs:dayTimeDuration("PT1H30M")'
            case "xs:yearMonthDuration" return 'xs:yearMonthDuration("P1Y6M")'
            case "xs:anyURI"        return '"http://example.com"'
            case "xs:anyAtomicType" return '"foo"'
            case "xs:QName"         return 'xs:QName("fn:concat")'
            case "node()"           return if ($is-seq) then "(<a>1</a>, <b>2</b>, <c>3</c>)" else "<item>value</item>"
            case "element()"        return if ($is-seq) then "(<x>1</x>, <y>2</y>)" else "<element>text</element>"
            case "document-node()"  return 'doc("/db/apps/docs/data/try-it/ft/data/poems.xml")'
            case "item()"           return
                if ($is-seq) then '(1, "two", <three/>)'
                else if ($var-name = "separator") then '", "'
                else '"hello"'
            case "map(*)"           return 'map { "a": 1, "b": 2 }'
            case "array(*)"         return '["x", "y", "z"]'
            case "function(*)"      return "function($x) { $x }"
            default                 return
                if (starts-with($base, "xs:")) then '"example"'
                else if (starts-with($base, "map(")) then 'map { "key": "value" }'
                else if (starts-with($base, "array(")) then '["a", "b"]'
                else if (starts-with($base, "function(")) then "function($x) { $x }"
                else '"example"'
};

(:~ Generate a try-it query from a function's parameter info :)
declare function local:generate-query($fn as map(*)) as xs:string {
    let $name := $fn?name
    let $params := $fn?parameters?*
    return
        if (empty($params)) then
            $name || "()"
        else
            let $lets :=
                for $p in $params
                let $var := "$" || $p?name
                let $type := ($p?type || $p?occurrence, "item()")[1]
                let $default := local:default-for-type($type, $p?name)
                return "let " || $var || " := " || $default
            let $args := string-join($params ! ("$" || ?name), ", ")
            return
                string-join($lets, "&#10;") || "&#10;return&#10;    " || $name || "(" || $args || ")"
};

(:~ Create the try-it .xq file in the database :)
declare function local:create-file(
    $prefix as xs:string,
    $fn as map(*),
    $query as xs:string
) {
    let $local-name := $fn?local-name
    let $arity := string($fn?arity)
    let $dir-path := string-join(($local:tryit-root, $prefix, $local-name, $arity), "/")
    let $filename := $prefix || "_" || $local-name || "_" || $arity || ".xq"
    (: Ensure directory exists :)
    let $_ :=
        if (xmldb:collection-available($dir-path)) then ()
        else
            let $parts := tokenize(substring-after($dir-path, $local:tryit-root || "/"), "/")
            return fold-left($parts, $local:tryit-root, function($parent, $child) {
                let $path := $parent || "/" || $child
                return (
                    if (xmldb:collection-available($path)) then ()
                    else xmldb:create-collection($parent, $child),
                    $path
                )[last()]
            })
    return (
        xmldb:store($dir-path, $filename, $query, "application/xquery"),
        $prefix || ":" || $fn?local-name || "#" || $arity
    )
};

(: === Main === :)
let $created :=
    for $prefix in $local:prefixes
    let $module := fundocs:get-module($prefix)[1]
    for $fn in $module?functions?*
    let $existing := tryit:find($prefix, $fn?local-name, xs:integer($fn?arity))
    where empty($existing)
    let $query := local:generate-query($fn)
    return local:create-file($prefix, $fn, $query)
return
    <summary>
        <created count="{count($created)}">
            { for $name in $created return <function>{$name}</function> }
        </created>
    </summary>
