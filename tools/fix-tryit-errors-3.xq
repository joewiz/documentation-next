xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:media-type "text/plain";

declare variable $local:root := "/db/apps/docs/data/try-it";

declare variable $local:fixes := map {
    "fn/char/1":
        '(: fn:char returns a character by its Unicode name :)&#10;char("LATIN SMALL LETTER A")',

    "fn/csv-to-arrays/2":
        'let $csv := "name,age,city&#10;Alice,25,NYC&#10;Bob,30,LA"&#10;let $options := map { "header": true() }&#10;return&#10;    csv-to-arrays($csv, $options)',

    "fn/csv-to-xml/2":
        'let $csv := "name,age,city&#10;Alice,25,NYC&#10;Bob,30,LA"&#10;let $options := map { "header": true() }&#10;return&#10;    csv-to-xml($csv, $options)',

    "fn/parse-csv/2":
        'let $csv := "name,age,city&#10;Alice,25,NYC&#10;Bob,30,LA"&#10;let $options := map { "header": true() }&#10;return&#10;    parse-csv($csv, $options)',

    "fn/load-xquery-module/1":
        '(: load-xquery-module dynamically loads a module :)&#10;let $mod := load-xquery-module("http://www.w3.org/2005/xpath-functions/math")&#10;return&#10;    map:keys($mod?functions)',

    "fn/load-xquery-module/2":
        '(: load-xquery-module with options :)&#10;let $mod := load-xquery-module("http://www.w3.org/2005/xpath-functions/math", map {})&#10;return&#10;    map:keys($mod?functions)',

    "fn/round/3":
        '(: round#3 with precision and rounding mode :)&#10;let $arg := 2.55&#10;let $precision := 1&#10;return&#10;    round($arg, $precision, "half-to-even")',

    "fn/sort-by/2":
        '(: sort-by sorts by extracted keys :)&#10;let $people := (&#10;    map { "name": "Charlie", "age": 30 },&#10;    map { "name": "Alice", "age": 25 },&#10;    map { "name": "Bob", "age": 35 }&#10;)&#10;return&#10;    sort-by($people, map { "key": function($m) { $m?age } })',

    "fn/unparsed-binary/1":
        '(: unparsed-binary loads binary content :)&#10;try {&#10;    let $data := unparsed-binary("/db/apps/docs/resources/favicon.ico")&#10;    return "Loaded " || string-length(string($data)) || " base64 chars"&#10;} catch * {&#10;    "unparsed-binary: " || $err:description&#10;}',

    "ft/has-index/1":
        '(: Check whether collections have a Lucene index :)&#10;for $path in ("/db/apps/docs/data/functions", "/db/apps/docs/data/articles")&#10;return&#10;    $path || ": " || ft:has-index($path)'
};

let $fixed :=
    for $key in map:keys($local:fixes)
    let $parts := tokenize($key, "/")
    let $dir := string-join(($local:root, $parts[1], $parts[2], $parts[3]), "/")
    let $filename := $parts[1] || "_" || $parts[2] || "_" || $parts[3] || ".xq"
    where xmldb:collection-available($dir)
    return (
        xmldb:store($dir, $filename, $local:fixes($key), "application/xquery"),
        $key
    )
return string-join(("Fixed " || count($fixed), for $f in $fixed order by $f return "  " || $f), "&#10;")
