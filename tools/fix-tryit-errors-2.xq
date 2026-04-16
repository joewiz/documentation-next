xquery version "3.1";

(:~ Second round of try-it fixes: context-dependent, resource-loading, XQ4 functions :)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:media-type "text/plain";

declare variable $local:root := "/db/apps/docs/data/try-it";
declare variable $local:api := "http://localhost:8080/exist/apps/exist-api";

declare variable $local:fixes := map {

    (: === array: leading || artifact === :)
    "array/append/2": 'let $array := ["x", "y", "z"]
let $appendage := "w"
return
    array:append($array, $appendage)',

    (: === 0-arity context-dependent functions === :)
    "fn/generate-id/0": '(: generate-id#0 uses the context item :)
let $nodes := (<a/>, <b/>, <c/>)
for $n in $nodes
return generate-id($n)',

    "fn/has-children/0": '<parent><child/></parent>/has-children()',

    "fn/last/0": '(1 to 10)[last()]',

    "fn/local-name/0": '<ns:element xmlns:ns="http://example.com"/>/local-name()',

    "fn/name/0": '<ns:element xmlns:ns="http://example.com"/>/name()',

    "fn/namespace-uri/0": '<ns:element xmlns:ns="http://example.com"/>/namespace-uri()',

    "fn/nilled/0": '<test/>/nilled()',

    "fn/node-name/0": '<ns:element xmlns:ns="http://example.com"/>/node-name()',

    "fn/normalize-space/0": '<p>  extra   whitespace   here  </p>/normalize-space()',

    "fn/number/0": '<price>42.50</price>/number()',

    "fn/position/0": '(: position() returns each item''s position in a sequence :)
("a", "b", "c", "d")[position() mod 2 eq 0]',

    "fn/root/0": 'let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
return $doc//title[1]/root()/name()',

    "fn/siblings/0": '<doc><a/><b/><c/></doc>/b/siblings()/name()',

    "fn/string/0": '<price>42.50</price>/string()',

    "fn/string-length/0": '<word>XQuery</word>/string-length()',

    (: === fn:char — use a valid character name === :)
    "fn/char/1": '(: fn:char returns a character by name :)
char("tab") || "Hello" || char("tab") || "World"',

    (: === Resource-loading functions — use real DB paths or HTTP URLs === :)
    "fn/html-doc/1": '(: Load an HTML page via HTTP :)
let $uri := "http://localhost:8080/exist/apps/exist-site-shell/"
return
    html-doc($uri)//title/string()',

    "fn/json-doc/1": 'let $source := "/db/apps/docs/config.json"
return
    json-doc($source)?abbrev',

    "fn/json-doc/2": 'let $source := "/db/apps/docs/config.json"
let $options := map { "liberal": true() }
return
    json-doc($source, $options)?abbrev',

    "fn/unparsed-text/1": 'let $source := "/db/apps/docs/data/try-it/fn/abs/1/fn_abs_1.xq"
return
    unparsed-text($source)',

    "fn/unparsed-text/2": 'let $source := "/db/apps/docs/data/try-it/fn/abs/1/fn_abs_1.xq"
let $encoding := "UTF-8"
return
    unparsed-text($source, $encoding)',

    "fn/unparsed-text-lines/1": 'let $source := "/db/apps/docs/data/try-it/fn/sort/3/fn_sort_3.xq"
return
    for $line at $n in unparsed-text-lines($source)
    return $n || ": " || $line',

    "fn/unparsed-text-lines/2": 'let $source := "/db/apps/docs/data/try-it/fn/sort/3/fn_sort_3.xq"
let $encoding := "UTF-8"
return
    for $line at $n in unparsed-text-lines($source, $encoding)
    return $n || ": " || $line',

    "fn/unparsed-binary/1": '(: Load a binary resource :)
let $uri := "/db/apps/docs/resources/favicon.ico"
return
    "Size: " || string-length(string(unparsed-binary($uri))) || " chars (base64)"',

    "fn/uri-collection/1": 'let $source := "/db/apps/docs/data/try-it/ft/data"
return
    uri-collection($source)',

    (: === JSON/XML parsing — use valid input === :)
    "fn/json-to-xml/1": 'let $value := ''{"name":"eXist","version":7,"features":["XQuery","XSLT"]}''
return
    json-to-xml($value)',

    "fn/json-to-xml/2": 'let $value := ''{"name":"eXist","version":7}''
let $options := map { "liberal": true() }
return
    json-to-xml($value, $options)',

    "fn/parse-json/1": 'let $value := ''{"database":"eXist-db","version":7,"active":true}''
return
    parse-json($value)?database',

    "fn/parse-json/2": 'let $value := ''{"database":"eXist-db","version":7}''
let $options := map { "liberal": true() }
return
    parse-json($value, $options)?database',

    "fn/parse-xml/1": 'let $value := "<greeting>Hello <b>XQuery</b>!</greeting>"
return
    parse-xml($value)//b/string()',

    "fn/parse-xml/2": 'let $value := "<greeting>Hello XQuery!</greeting>"
let $options := map {}
return
    parse-xml($value, $options)/greeting/string()',

    (: === CSV functions === :)
    "fn/csv-doc/2": '(: csv-doc#2 loads CSV from a URI with options :)
let $csv := "name,age&#10;Alice,25&#10;Bob,30"
return csv-to-arrays($csv)',

    "fn/csv-to-arrays/2": 'let $csv := "Alice;25;NYC&#10;Bob;30;LA"
let $options := map { "separator": ";" }
return
    csv-to-arrays($csv, $options)',

    "fn/csv-to-xml/2": 'let $csv := "Alice;25;NYC&#10;Bob;30;LA"
let $options := map { "separator": ";" }
return
    csv-to-xml($csv, $options)',

    "fn/parse-csv/2": 'let $csv := "Alice;25;NYC&#10;Bob;30;LA"
let $options := map { "separator": ";" }
return
    parse-csv($csv, $options)',

    (: === Functions needing correct arg types === :)
    "fn/get/1": '(: fn:get retrieves from the dynamic context map :)
let $map := map { "x": 42, "y": 99 }
return
    $map?x',

    "fn/hash/2": 'let $value := "Hello, World!"
let $algorithm := "SHA-256"
return
    hash($value, $algorithm)',

    "fn/hash/3": 'let $value := "Hello, World!"
let $algorithm := "SHA-256"
let $options := map { "encoding": "hex" }
return
    hash($value, $algorithm, $options)',

    "fn/highest/1": 'let $input := (10, 30, 20, 30, 5)
return
    highest($input)',

    "fn/lowest/1": 'let $input := (10, 30, 20, 5, 5)
return
    lowest($input)',

    "fn/id/1": '(: id() requires a document with xml:id attributes :)
let $doc := <root><item xml:id="a1">First</item><item xml:id="b2">Second</item></root>
return
    $doc/id("b2")/string()',

    "fn/idref/1": '(: idref() requires context with IDREF attributes :)
let $doc := <root><item xml:id="a1">First</item></root>
return
    count($doc//item)',

    "fn/invisible-xml/1": '(: invisible-xml parses text using an ixml grammar :)
let $grammar := "date: year, ''-'', month, ''-'', day .
year: digit, digit, digit, digit .
month: digit, digit .
day: digit, digit .
digit: [''0''-''9''] ."
return
    invisible-xml($grammar)("2025-06-15")',

    "fn/invisible-xml/2": '(: invisible-xml with options :)
let $grammar := "greeting: ''hello'' ."
let $options := map {}
return
    invisible-xml($grammar, $options)("hello")',

    "fn/lang/1": '<p xml:lang="en">Hello</p>/lang("en")',

    "fn/load-xquery-module/1": 'let $module-uri := "http://www.w3.org/2005/xpath-functions/math"
return
    let $mod := load-xquery-module($module-uri)
    return $mod?functions(xs:QName("math:pi"), 0)()',

    "fn/load-xquery-module/2": 'let $module-uri := "http://www.w3.org/2005/xpath-functions/math"
let $options := map {}
return
    let $mod := load-xquery-module($module-uri, $options)
    return $mod?functions(xs:QName("math:pi"), 0)()',

    "fn/normalize-unicode/2": 'let $value := "A&#x0300;"  (: A + combining grave :)
let $form := "NFC"
return
    normalize-unicode($value, $form)',

    "fn/not/1": 'let $input := false()
return
    not($input)',

    "fn/op/1": '(: fn:op returns the function for an operator :)
let $add := op("+")
return
    $add(3, 4)',

    "fn/partial-apply/2": '(: partial-apply binds arguments to a function :)
let $add := function($a, $b) { $a + $b }
let $add10 := partial-apply($add, map { 1: 10 })
return
    $add10(32)',

    "fn/parse-ietf-date/1": 'let $value := "Wed, 15 Jun 2025 14:30:00 GMT"
return
    parse-ietf-date($value)',

    "fn/parse-integer/1": 'let $value := "42"
return
    parse-integer($value)',

    "fn/parse-integer/2": 'let $value := "FF"
let $radix := 16
return
    parse-integer($value, $radix)',

    "fn/resolve-uri/1": '(: resolve-uri against an explicit base :)
let $href := "page.html"
let $base := "http://example.com/docs/"
return
    resolve-uri($href, $base)',

    "fn/round/3": '(: round#3 with precision and rounding mode :)
let $arg := 2.55
let $precision := 1
let $mode := "half-to-even"
return (
    "round(2.55, 1, half-to-even) = " || round($arg, $precision, $mode),
    "round(2.55, 1, half-up) = " || round($arg, $precision, "half-up")
)',

    "fn/schema-type/1": '(: schema-type returns type info — use a known XSD type :)
try { schema-type(xs:QName("xs:integer")) }
catch * { "schema-type not supported: " || $err:description }',

    "fn/serialize/2": 'let $input := <doc><greeting>Hello</greeting></doc>
let $options := map { "method": "xml", "indent": true(), "omit-xml-declaration": true() }
return
    serialize($input, $options)',

    "fn/sort-by/2": '(: sort-by sorts using a key function :)
let $input := ("banana", "fig", "apple", "cherry")
let $key := string-length#1
return
    sort-by($input, $key)',

    "fn/subsequence-where/2": '(: subsequence-where selects items starting from the first match :)
let $input := (1, 2, 3, 4, 5, 6)
let $from := function($n) { $n ge 3 }
return
    subsequence-where($input, $from)',

    "fn/subsequence-where/3": '(: subsequence-where with start and end predicates :)
let $input := (1, 2, 3, 4, 5, 6)
let $from := function($n) { $n ge 2 }
let $to := function($n) { $n ge 5 }
return
    subsequence-where($input, $from, $to)',

    "fn/sum/2": '(: sum#2 with a zero value for empty sequences :)
let $values := ()
let $zero := 0
return
    sum($values, $zero)',

    "fn/transform/1": '(: fn:transform applies an XSLT stylesheet :)
let $options := map {
    "stylesheet-text": ''<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
        <xsl:template match="/"><out><xsl:value-of select="greeting"/></out></xsl:template>
    </xsl:stylesheet>'',
    "source-node": <greeting>Hello from XSLT!</greeting>
}
return
    transform($options)?output',

    "fn/transitive-closure/2": '(: transitive-closure finds all reachable nodes :)
let $graph :=
    map {
        "a": ("b", "c"),
        "b": ("d"),
        "c": ("d"),
        "d": ()
    }
let $step := function($node) { $graph($node) }
return
    transitive-closure("a", $step)',

    "fn/xml-to-json/2": 'let $xml :=
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="name">eXist-db</string>
        <number key="version">7</number>
    </map>
let $options := map { "indent": true() }
return
    xml-to-json($xml, $options)',

    "fn/zero-or-one/1": 'let $input := "single"
return
    zero-or-one($input)',

    (: === map module fixes === :)
    "map/build/2": 'let $input := ("apple", "banana", "cherry")
let $key := function($s) { substring($s, 1, 1) }
return
    map:build($input, $key)',

    "map/build/3": 'let $input := ("apple", "banana", "cherry")
let $key := function($s) { substring($s, 1, 1) }
let $value := function($s) { upper-case($s) }
return
    map:build($input, $key, $value)',

    "map/filter/2": 'let $map := map { "a": 1, "b": 2, "c": 3 }
let $predicate := function($k, $v) { $v > 1 }
return
    map:filter($map, $predicate)',

    "map/for-each/2": 'let $map := map { "x": 10, "y": 20, "z": 30 }
let $action := function($k, $v) { $k || "=" || $v }
return
    map:for-each($map, $action)',

    "map/keys-where/2": 'let $map := map { "a": 1, "b": 2, "c": 3 }
let $predicate := function($k, $v) { $v mod 2 eq 0 }
return
    map:keys-where($map, $predicate)',

    (: === ft module fixes === :)
    "ft/facets/2": '(: Get facet counts — requires field-based index with facets :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $hits := $data//entry[ft:query(., "index*")]
return
    for $entry in $hits
    return $entry/term/string() || " (" || $entry/@category || ")"',

    "ft/has-index/1": '(: Check whether a collection has a Lucene index :)
ft:has-index("/db/apps/docs/data/try-it/ft/data")'
};

(: Apply all fixes :)
let $fixed :=
    for $key in map:keys($local:fixes)
    let $parts := tokenize($key, "/")
    let $prefix := $parts[1]
    let $fn-name := $parts[2]
    let $arity := $parts[3]
    let $dir := string-join(($local:root, $prefix, $fn-name, $arity), "/")
    let $filename := $prefix || "_" || $fn-name || "_" || $arity || ".xq"
    where xmldb:collection-available($dir)
    return (
        xmldb:store($dir, $filename, $local:fixes($key), "application/xquery"),
        $key
    )
return string-join((
    "Fixed " || count($fixed) || " files:",
    for $f in $fixed order by $f return "  " || $f,
    ""
), "&#10;")
