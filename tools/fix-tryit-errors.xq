xquery version "3.1";

(:~
 : Fix common issues in auto-generated try-it .xq files.
 : Rewrites files in-place in the database.
 :
 : Run via: curl -s -u admin: http://localhost:8080/exist/rest/db/apps/docs/fix-tryit-errors.xq
 :)

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:media-type "text/plain";

declare variable $local:root := "/db/apps/docs/data/try-it";

(: Map of function path → corrected query content :)
declare variable $local:fixes := map {
    (: === array module fixes === :)
    "array/fold-left/3":   'let $array := ["a", "b", "c"]
let $zero := ""
let $function := function($acc, $item) { $acc || $item }
return
    array:fold-left($array, $zero, $function)',

    "array/fold-right/3":  'let $array := [1, 2, 3, 4, 5]
let $zero := 0
let $function := function($item, $acc) { $acc + $item }
return
    array:fold-right($array, $zero, $function)',

    "array/for-each-pair/3": 'let $array1 := [1, 2, 3]
let $array2 := [10, 20, 30]
let $action := function($a, $b) { $a + $b }
return
    array:for-each-pair($array1, $array2, $action)',

    "array/get/2":         'let $array := ["x", "y", "z"]
let $index := 2
return
    array:get($array, $index)',

    "array/insert-before/3": 'let $array := ["a", "b", "c"]
let $position := 2
let $member := "NEW"
return
    array:insert-before($array, $position, $member)',

    "array/put/3":         'let $array := ["a", "b", "c"]
let $position := 2
let $member := "REPLACED"
return
    array:put($array, $position, $member)',

    "array/remove/2":      'let $array := ["a", "b", "c", "d"]
let $positions := (2, 4)
return
    array:remove($array, $positions)',

    "array/sort-with/2":   'let $array := [3, 1, 4, 1, 5]
let $comparator := function($a, $b) { if ($a lt $b) then -1 else if ($a gt $b) then 1 else 0 }
return
    array:sort-with($array, $comparator)',

    "array/sort/2":        'let $array := ["banana", "apple", "cherry"]
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    array:sort($array, $collation)',

    "array/sort/3":        'let $array := [map{"name":"Charlie","age":30}, map{"name":"Alice","age":25}, map{"name":"Bob","age":35}]
let $collation := ()
let $key := function($m) { $m?age }
return
    array:sort($array, $collation, $key)',

    "array/subarray/2":    'let $array := ["a", "b", "c", "d", "e"]
let $start := 2
return
    array:subarray($array, $start)',

    "array/subarray/3":    'let $array := ["a", "b", "c", "d", "e"]
let $start := 2
let $length := 3
return
    array:subarray($array, $start, $length)',

    (: === fn module fixes - collation/flags params === :)
    "fn/analyze-string/3": 'let $input := "The year 2025 was great, and 2026 is better"
let $pattern := "\d{4}"
let $flags := "i"
return
    analyze-string($input, $pattern, $flags)',

    "fn/apply/2":          'let $function := function($a, $b) { $a + $b }
let $array := [3, 4]
return
    apply($function, $array)',

    "fn/avg/1":            'let $values := (10, 20, 30, 40, 50)
return
    avg($values)',

    "fn/base-uri/0":       '(: base-uri#0 requires a context node; use base-uri#1 instead :)
let $node := <test xml:base="http://example.com/doc"/>
return
    base-uri($node)',

    "fn/boolean/1":        'let $input := "non-empty string"
return
    boolean($input)',

    "fn/char/1":           'let $value := "newline"
return
    char($value)',

    "fn/civil-timezone/2": 'let $value := current-dateTime()
let $place := "America/New_York"
return
    civil-timezone($value, $place)',

    "fn/codepoints-to-string/1": 'let $values := (72, 101, 108, 108, 111)
return
    codepoints-to-string($values)',

    "fn/collation-key/2":  'let $value := "hello"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    collation-key($value, $collation)',

    "fn/collection/0":     '(: collection#0 returns the default collection :)
count(collection("/db/apps/docs/data"))',

    "fn/compare/3":        'let $value-1 := "Straße"
let $value-2 := "Strasse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de"
return
    compare($value-1, $value-2, $collation)',

    "fn/concat/1":         '(: concat requires at least 2 arguments :)
concat("Hello", " ", "World")',

    "fn/contains-subsequence/3": 'let $input := (1, 2, 3, 4, 5)
let $subsequence := (2, 3)
let $compare := function($a, $b) { $a eq $b }
return
    contains-subsequence($input, $subsequence, $compare)',

    "fn/contains-token/3": 'let $value := "red green blue"
let $token := "green"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    contains-token($value, $token, $collation)',

    "fn/contains/3":       'let $source := "Straße"
let $substring := "strasse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de;strength=secondary"
return
    contains($source, $substring, $collation)',

    "fn/csv-doc/1":        '(: csv-doc loads CSV from a URI — demo with csv-to-arrays instead :)
let $csv := "name,age&#10;Alice,25&#10;Bob,30"
return
    csv-to-arrays($csv)',

    "fn/csv-doc/2":        '(: csv-doc loads CSV from a URI — demo with csv-to-arrays instead :)
let $csv := "Alice;25&#10;Bob;30"
let $options := map { "separator": ";" }
return
    csv-to-arrays($csv, $options)',

    "fn/csv-to-arrays/2":  'let $csv := "Alice;25&#10;Bob;30"
let $options := map { "separator": ";" }
return
    csv-to-arrays($csv, $options)',

    "fn/csv-to-xml/2":     'let $csv := "Alice;25&#10;Bob;30"
let $options := map { "separator": ";" }
return
    csv-to-xml($csv, $options)',

    "fn/deep-equal/3":     'let $items-1 := (1, 2, 3)
let $items-2 := (1, 2, 3)
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    deep-equal($items-1, $items-2, $collation)',

    "fn/distinct-values/2": 'let $values := ("apple", "APPLE", "Apple")
let $collation := "http://www.w3.org/2013/collation/UCA?strength=secondary"
return
    distinct-values($values, $collation)',

    "fn/do-until/3":       'let $input := 1
let $action := function($n) { $n * 2 }
let $predicate := function($n) { $n > 100 }
return
    do-until($input, $action, $predicate)',

    "fn/doc/1":            '(: Load and query an XML document from the database :)
let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
return (
    "Poems: " || count($doc//poem),
    for $title in $doc//title return "  - " || $title
)',

    "fn/document-uri/0":   '(: document-uri#0 needs a context node; using #1 instead :)
let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
return
    document-uri($doc)',

    "fn/element-with-id/0": '(: element-with-id needs an XML document with ID attributes :)
let $doc := <root><item xml:id="a1">First</item><item xml:id="b2">Second</item></root>
return
    $doc/id("a1")',

    "fn/element-with-id/1": '(: element-with-id needs an XML document with ID attributes :)
let $doc := <root><item xml:id="a1">First</item><item xml:id="b2">Second</item></root>
return
    $doc/id("a1")/string()',

    "fn/ends-with-subsequence/3": 'let $input := (1, 2, 3, 4, 5)
let $subsequence := (4, 5)
let $compare := function($a, $b) { $a eq $b }
return
    ends-with-subsequence($input, $subsequence, $compare)',

    "fn/ends-with/3":      'let $source := "Straße"
let $suffix := "sse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de;strength=secondary"
return
    ends-with($source, $suffix, $collation)',

    "fn/equals/3":         'let $source := "Straße"
let $target := "strasse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de;strength=secondary"
return
    equals($source, $target, $collation)',

    "fn/error/0":          '(: fn:error always raises an error — wrapped in try/catch for demo :)
try { error() }
catch * { "Caught: " || $err:code || " — " || $err:description }',

    "fn/error/1":          '(: fn:error#1 raises an error with a code :)
try { error(xs:QName("app:DEMO001")) }
catch * { "Caught: " || $err:code }',

    "fn/error/2":          '(: fn:error#2 raises an error with code and description :)
try { error(xs:QName("app:DEMO001"), "Something went wrong") }
catch * { "Caught: " || $err:code || " — " || $err:description }',

    "fn/error/3":          '(: fn:error#3 raises an error with code, description, and value :)
try { error(xs:QName("app:DEMO001"), "Bad value", 42) }
catch * { "Code: " || $err:code || ", Message: " || $err:description || ", Value: " || $err:value }',

    "fn/every/2":          'let $input := (2, 4, 6, 8)
let $predicate := function($n) { $n mod 2 = 0 }
return
    every($input, $predicate)',

    "fn/exactly-one/1":    'let $input := "single item"
return
    exactly-one($input)',

    "fn/fold-right/3":     'let $sequence := ("a", "b", "c")
let $zero := ""
let $function := function($item, $acc) { $acc || $item }
return
    fold-right($sequence, $zero, $function)',

    "fn/for-each-pair/3":  'let $seq1 := (1, 2, 3)
let $seq2 := (10, 20, 30)
let $function := function($a, $b) { $a * $b }
return
    for-each-pair($seq1, $seq2, $function)',

    (: More fn fixes for various issues :)
    "fn/highest/2":        'let $input := (10, 30, 20, 30)
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    highest($input, $collation)',

    "fn/highest/3":        'let $input := ("banana", "apple", "cherry")
let $collation := ()
let $key := function($s) { string-length($s) }
return
    highest($input, $collation, $key)',

    "fn/index-of/3":       'let $input := ("apple", "APPLE", "Apple")
let $target := "apple"
let $collation := "http://www.w3.org/2013/collation/UCA?strength=secondary"
return
    index-of($input, $target, $collation)',

    "fn/lowest/2":         'let $input := (10, 30, 20, 10)
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    lowest($input, $collation)',

    "fn/lowest/3":         'let $input := ("banana", "apple", "cherry")
let $collation := ()
let $key := function($s) { string-length($s) }
return
    lowest($input, $collation, $key)',

    "fn/matches/3":        'let $input := "Hello World"
let $pattern := "hello"
let $flags := "i"
return
    matches($input, $pattern, $flags)',

    "fn/max/2":            'let $values := ("banana", "apple", "cherry")
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    max($values, $collation)',

    "fn/min/2":            'let $values := ("banana", "apple", "cherry")
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    min($values, $collation)',

    "fn/one-or-more/1":    'let $input := (1, 2, 3)
return
    one-or-more($input)',

    "fn/partial-apply/2":  'let $function := concat#3
let $arguments := map { 1: "Hello " }
return
    partial-apply($function, $arguments)("World", "!")',

    "fn/replace/3":        'let $input := "The quick brown fox"
let $pattern := "fox"
let $replacement := "cat"
return
    replace($input, $pattern, $replacement)',

    "fn/replace/4":        'let $input := "Hello World"
let $pattern := "hello"
let $replacement := "Hi"
let $flags := "i"
return
    replace($input, $pattern, $replacement, $flags)',

    "fn/scan-left/3":      'let $input := (1, 2, 3, 4, 5)
let $init := 0
let $action := function($acc, $item) { $acc + $item }
return
    scan-left($input, $init, $action)',

    "fn/scan-right/3":     'let $input := (1, 2, 3, 4, 5)
let $init := 0
let $action := function($item, $acc) { $acc + $item }
return
    scan-right($input, $init, $action)',

    "fn/some/2":           'let $input := (1, 3, 5, 8, 9)
let $predicate := function($n) { $n mod 2 = 0 }
return
    some($input, $predicate)',

    "fn/sort/2":           '(: sort#2 with collation :)
sort(("Über", "alpha", "Ångström", "beta"),
     "http://www.w3.org/2013/collation/UCA?lang=en")',

    "fn/sort-by/2":        'let $input := ("banana", "fig", "apple", "cherry")
let $keys := function($s) { string-length($s) }
return
    sort-by($input, $keys)',

    "fn/sort-with/2":      'let $input := (3, 1, 4, 1, 5, 9)
let $comparator := function($a, $b) { if ($a lt $b) then -1 else if ($a gt $b) then 1 else 0 }
return
    sort-with($input, $comparator)',

    "fn/starts-with/3":    'let $source := "Straße"
let $prefix := "str"
let $collation := "http://www.w3.org/2013/collation/UCA?strength=secondary"
return
    starts-with($source, $prefix, $collation)',

    "fn/starts-with-subsequence/3": 'let $input := (1, 2, 3, 4, 5)
let $subsequence := (1, 2)
let $compare := function($a, $b) { $a eq $b }
return
    starts-with-subsequence($input, $subsequence, $compare)',

    "fn/substring-after/3": 'let $value := "Straße"
let $substring := "ra"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    substring-after($value, $substring, $collation)',

    "fn/substring-before/3": 'let $value := "Straße"
let $substring := "ße"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    substring-before($value, $substring, $collation)',

    "fn/tokenize/3":       'let $value := "one:two::three"
let $pattern := ":"
let $flags := ""
return
    tokenize($value, $pattern, $flags)',

    "fn/transitive-closure/2": 'let $data := map { "a": ("b","c"), "b": ("d",), "c": ("d",), "d": () }
let $input := "a"
let $step := function($item) { $data($item) }
return
    transitive-closure($input, $step)',

    "fn/while-do/3":       'let $input := 1
let $predicate := function($n) { $n lt 100 }
let $action := function($n) { $n * 2 }
return
    while-do($input, $predicate, $action)'
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
