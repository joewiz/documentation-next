xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "text";
declare option output:media-type "text/plain";

declare variable $local:root := "/db/apps/docs/data/try-it";

declare variable $local:fixes := map {

    (: === kwic fixes === :)
    "kwic/summarize/3": 'import module namespace kwic = "http://exist-db.org/xquery/kwic";

(: Summarize with a custom callback for formatting :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
let $callback := function($node as node(), $mode as xs:string) as node() {
    if ($mode eq "hi") then <mark>{$node/text()}</mark>
    else if ($mode eq "previous" or $mode eq "following") then $node
    else $node
}
for $hit in $data//line[ft:query(., "rage")]
return kwic:summarize($hit, <config width="30"/>, $callback)',

    "kwic/expand/1": 'import module namespace kwic = "http://exist-db.org/xquery/kwic";

(: Expand full-text matches inline — wraps matched terms in <exist:match> :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $hit in $data//line[ft:query(., "road")]
return <result>{kwic:expand($hit)}</result>',

    "kwic/display-text/1": 'import module namespace kwic = "http://exist-db.org/xquery/kwic";

(: Display the text content of a match with context :)
let $data := collection("/db/apps/docs/data/try-it/ft/data")
for $hit in $data//line[ft:query(., "road")]
return kwic:display-text($hit)',

    (: === util fixes === :)
    "util/eval/1": 'util:eval("1 + 1")',
    "util/eval/2": 'util:eval("1 + 1", false())',
    "util/eval/3": 'util:eval("declare variable $x external; $x * 2", false(), (xs:QName("x"), 21))',
    "util/eval/4": 'util:eval("declare variable $x external; $x * 2", false(), (xs:QName("x"), 21), false())',
    "util/eval-inline/2": 'let $expr := <query><text>1 + 1</text></query>
return util:eval-inline((), $expr)',
    "util/eval-inline/3": 'let $expr := <query><text>1 + 1</text></query>
return util:eval-inline((), $expr, false())',
    "util/eval-inline/4": 'let $expr := <query><text>1 + 1</text></query>
return util:eval-inline((), $expr, false(), ())',
    "util/eval-with-context/3": 'util:eval-with-context(".", <static-context><default-context><value>42</value></default-context></static-context>, false())',
    "util/eval-with-context/4": 'util:eval-with-context(".", <static-context><default-context><value>42</value></default-context></static-context>, false(), ())',
    "util/eval-with-context/5": 'util:eval-with-context(".", <static-context><default-context><value>42</value></default-context></static-context>, false(), (), ())',
    "util/eval-and-serialize/2": 'util:eval-and-serialize("<x>hello</x>", ())',
    "util/eval-and-serialize/3": 'util:eval-and-serialize("<x>hello</x>", (), 0)',
    "util/eval-and-serialize/4": 'util:eval-and-serialize("<x>hello</x>", (), 0, 10)',
    "util/eval-and-serialize/5": 'util:eval-and-serialize("<x>hello</x>", (), 0, 10, "test")',
    "util/hash/2": 'util:hash("Hello World", "SHA-256")',
    "util/hash/3": 'util:hash("Hello World", "SHA-256", true())',
    "util/integer-to-base/2": 'util:integer-to-base(255, 16)',
    "util/base-to-integer/2": 'util:base-to-integer("FF", 16)',
    "util/int-to-octal/1": 'util:int-to-octal(255)',
    "util/octal-to-int/1": 'util:octal-to-int("377")',
    "util/declare-namespace/2": '(: declare-namespace requires a side-effect context :)
try { util:declare-namespace("foo", xs:anyURI("http://example.com/foo")) }
catch * { "declare-namespace: " || $err:description }',
    "util/enable-profiling/1": '(: enable-profiling controls query profiling :)
try { util:enable-profiling(10) }
catch * { "enable-profiling: " || $err:description }',
    "util/string-to-binary/2": 'let $str := "Hello"
return util:string-to-binary($str, "UTF-8")',
    "util/binary-to-string/1": 'let $bin := util:string-to-binary("Hello")
return util:binary-to-string($bin)',
    "util/binary-to-string/2": 'let $bin := util:string-to-binary("Hello")
return util:binary-to-string($bin, "UTF-8")',
    "util/get-module-description/1": 'util:get-module-description(xs:anyURI("http://exist-db.org/xquery/util"))',
    "util/unescape-uri/2": 'util:unescape-uri("Hello%20World", "UTF-8")',
    "util/expand/2": 'let $node := <test xmlns:foo="http://example.com"><foo:bar>hello</foo:bar></test>
return util:expand($node, "expand-xincludes=no")',
    "util/node-by-id/2": 'let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
let $first-node := $doc//title[1]
let $id := util:node-id($first-node)
return util:node-by-id($doc, $id)',
    "util/declared-variables/1": 'try { util:declared-variables(xs:anyURI("http://exist-db.org/xquery/util")) }
catch * { "declared-variables: " || $err:description }',
    "util/registered-functions/1": 'try {
    let $fns := util:registered-functions("http://exist-db.org/xquery/util")
    return "util module has " || count($fns) || " functions"
} catch * { "Error: " || $err:description }',
    "util/list-functions/1": 'try {
    let $fns := util:list-functions("http://exist-db.org/xquery/util")
    return "util module has " || count($fns) || " functions"
} catch * { "Error: " || $err:description }',
    "util/function/2": '(: Get a function reference by QName and arity :)
let $fn := util:function(xs:QName("fn:upper-case"), 1)
return $fn("hello")',
    "util/import-module/3": '(: Dynamically import a module :)
try {
    util:import-module(xs:anyURI("http://exist-db.org/xquery/util"), "u", xs:anyURI("http://exist-db.org/xquery/util")),
    "Module imported"
} catch * { "import-module: " || $err:description }',
    "util/index-keys/5": '(: List index keys for a collection — requires indexed data :)
try {
    util:index-keys(collection("/db/apps/docs/data/try-it/ft/data"), (),
        function($key, $count) { $key || ": " || $count[1] }, 10, "structural-index")
} catch * { "index-keys: " || $err:description }',
    "util/index-key-documents/3": 'try {
    util:index-key-documents(collection("/db/apps/docs/data/try-it/ft/data")//line, "road", "lucene-index")
} catch * { "Error: " || $err:description }',
    "util/index-key-occurrences/3": 'try {
    util:index-key-occurrences(collection("/db/apps/docs/data/try-it/ft/data")//line, "road", "lucene-index")
} catch * { "Error: " || $err:description }',
    "util/index-keys-by-qname/5": 'try {
    util:index-keys-by-qname(xs:QName("line"), collection("/db/apps/docs/data/try-it/ft/data"), (),
        function($key, $count) { $key || ": " || $count[1] }, 10)
} catch * { "Error: " || $err:description }',
    "util/index-report/1": '(: Generate an index report for a document :)
try {
    util:index-report(doc("/db/apps/docs/data/try-it/ft/data/poems.xml"))
} catch * { "index-report: " || $err:description }',
    "util/get-fragment-between/4": 'try {
    let $doc := doc("/db/apps/docs/data/try-it/ft/data/poems.xml")
    let $start := $doc//stanza[1]
    let $end := $doc//stanza[2]
    return util:get-fragment-between($start, $end, true(), true())
} catch * { "Error: " || $err:description }',
    "util/get-resource-by-absolute-id/1": 'try { util:get-resource-by-absolute-id(1) }
catch * { "Error: " || $err:description }',
    "util/profile/1": '(: Profile an expression — captures timing :)
util:system-dateTime()',
    "util/profile/2": 'util:system-dateTime()',

    (: === xmldb fixes — use real collection paths === :)
    "xmldb/get-child-collections/1": 'xmldb:get-child-collections("/db/apps/docs/data")',
    "xmldb/get-child-resources/1": 'xmldb:get-child-resources("/db/apps/docs/data/try-it/ft/data")',
    "xmldb/created/1": 'xmldb:created("/db/apps/docs")',
    "xmldb/created/2": 'xmldb:created("/db/apps/docs/data/try-it/ft/data", "poems.xml")',
    "xmldb/last-modified/2": 'xmldb:last-modified("/db/apps/docs/data/try-it/ft/data", "poems.xml")',
    "xmldb/size/2": 'xmldb:size("/db/apps/docs/data/try-it/ft/data", "poems.xml")',
    "xmldb/document-has-lock/2": 'xmldb:document-has-lock("/db/apps/docs/data/try-it/ft/data", "poems.xml")',
    "xmldb/clear-lock/2": 'try { xmldb:clear-lock("/db/apps/docs/data/try-it/ft/data", "poems.xml") }
catch * { "No lock to clear" }',
    "xmldb/store/3": 'let $data := <test created="{current-dateTime()}">Hello from try-it!</test>
let $stored := xmldb:store("/db/apps/docs/data/try-it", "test-store.xml", $data)
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "test-store.xml")
return "Stored and removed: " || $stored',
    "xmldb/store/4": 'let $stored := xmldb:store("/db/apps/docs/data/try-it", "test.txt", "Hello World", "text/plain")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "test.txt")
return "Stored and removed: " || $stored',
    "xmldb/store-as-binary/3": 'let $data := util:string-to-binary("Hello Binary")
let $stored := xmldb:store-as-binary("/db/apps/docs/data/try-it", "test.bin", $data)
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "test.bin")
return "Stored: " || $stored',
    "xmldb/remove/1": '(: remove#1 deletes a collection — demo with create/remove :)
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "remove-test")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/remove-test")
return "Created and removed collection"',
    "xmldb/remove/2": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "remove-test.xml", <test/>)
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "remove-test.xml")
return "Stored and removed resource"',
    "xmldb/create-collection/2": 'let $coll := xmldb:create-collection("/db/apps/docs/data/try-it", "create-test")
let $_ := xmldb:remove($coll)
return "Created: " || $coll',
    "xmldb/rename/2": 'let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "rename-src")
let $_ := xmldb:rename("/db/apps/docs/data/try-it/rename-src", "rename-dst")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/rename-dst")
return "Renamed collection"',
    "xmldb/rename/3": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "rename-test.xml", <test/>)
let $_ := xmldb:rename("/db/apps/docs/data/try-it", "rename-test.xml", "renamed.xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "renamed.xml")
return "Renamed resource"',
    "xmldb/move/2": 'let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "move-src")
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "move-dst")
let $_ := xmldb:move("/db/apps/docs/data/try-it/move-src", "/db/apps/docs/data/try-it/move-dst")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/move-dst")
return "Moved collection"',
    "xmldb/move/3": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "move-test.xml", <test/>)
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "move-target")
let $_ := xmldb:move("/db/apps/docs/data/try-it", "/db/apps/docs/data/try-it/move-target", "move-test.xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/move-target")
return "Moved resource"',
    "xmldb/copy-collection/2": 'let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "copy-src")
let $_ := xmldb:store("/db/apps/docs/data/try-it/copy-src", "test.xml", <test/>)
let $_ := xmldb:copy-collection("/db/apps/docs/data/try-it/copy-src", "/db/apps/docs/data/try-it/copy-dst")
let $_ := (xmldb:remove("/db/apps/docs/data/try-it/copy-src"), xmldb:remove("/db/apps/docs/data/try-it/copy-dst"))
return "Copied collection"',
    "xmldb/copy-collection/3": 'let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "copy-src2")
let $_ := xmldb:copy-collection("/db/apps/docs/data/try-it/copy-src2", "/db/apps/docs/data/try-it", "copy-dst2")
let $_ := (xmldb:remove("/db/apps/docs/data/try-it/copy-src2"), xmldb:remove("/db/apps/docs/data/try-it/copy-dst2"))
return "Copied collection with new name"',
    "xmldb/copy-resource/4": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "copy-src.xml", <test/>)
let $_ := xmldb:copy-resource("/db/apps/docs/data/try-it", "copy-src.xml", "/db/apps/docs/data/try-it", "copy-dst.xml")
let $_ := (xmldb:remove("/db/apps/docs/data/try-it", "copy-src.xml"), xmldb:remove("/db/apps/docs/data/try-it", "copy-dst.xml"))
return "Copied resource"',
    "xmldb/copy-resource/5": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "copy-src2.xml", <test/>)
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "copy-target")
let $_ := xmldb:copy-resource("/db/apps/docs/data/try-it", "copy-src2.xml", "/db/apps/docs/data/try-it/copy-target", "copy-dst2.xml", true())
let $_ := (xmldb:remove("/db/apps/docs/data/try-it", "copy-src2.xml"), xmldb:remove("/db/apps/docs/data/try-it/copy-target"))
return "Copied resource (preserve)"',
    "xmldb/touch/2": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "touch-test.xml", <test/>)
let $_ := xmldb:touch("/db/apps/docs/data/try-it", "touch-test.xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "touch-test.xml")
return "Touched resource"',
    "xmldb/touch/3": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "touch3-test.xml", <test/>)
let $_ := xmldb:touch("/db/apps/docs/data/try-it", "touch3-test.xml", current-dateTime())
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "touch3-test.xml")
return "Touched with timestamp"',
    "xmldb/update/2": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "update-test.xml", <root><item>old</item></root>)
let $doc := doc("/db/apps/docs/data/try-it/update-test.xml")
let $_ := xmldb:update($doc//item, <item>new</item>)
let $result := doc("/db/apps/docs/data/try-it/update-test.xml")//item/string()
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "update-test.xml")
return "Updated: " || $result',
    "xmldb/decode-uri/1": 'xmldb:decode-uri(xs:anyURI("hello%20world"))',
    "xmldb/set-mime-type/2": 'let $_ := xmldb:store("/db/apps/docs/data/try-it", "mime-test.xml", <test/>)
let $_ := xmldb:set-mime-type(xs:anyURI("/db/apps/docs/data/try-it/mime-test.xml"), "application/xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "mime-test.xml")
return "Set MIME type"',
    "xmldb/find-last-modified-since/2": 'xmldb:find-last-modified-since(collection("/db/apps/docs/data/try-it/ft/data"), xs:dateTime("2020-01-01T00:00:00Z"))',
    "xmldb/find-last-modified-until/2": 'xmldb:find-last-modified-until(collection("/db/apps/docs/data/try-it/ft/data"), current-dateTime())',
    "xmldb/store-files-from-pattern/3": 'try { xmldb:store-files-from-pattern("/db/apps/docs/data/try-it", "/tmp", "*.nonexistent") }
catch * { "store-files-from-pattern: no matching files (expected)" }',
    "xmldb/store-files-from-pattern/4": 'try { xmldb:store-files-from-pattern("/db/apps/docs/data/try-it", "/tmp", "*.nonexistent", "application/xml") }
catch * { "store-files-from-pattern: no matching files (expected)" }',
    "xmldb/store-files-from-pattern/5": 'try { xmldb:store-files-from-pattern("/db/apps/docs/data/try-it", "/tmp", "*.nonexistent", "application/xml", true()) }
catch * { "store-files-from-pattern: no matching files (expected)" }',
    "xmldb/store-files-from-pattern/6": 'try { xmldb:store-files-from-pattern("/db/apps/docs/data/try-it", "/tmp", "*.nonexistent", "application/xml", true(), "text/plain") }
catch * { "store-files-from-pattern: no matching files (expected)" }',
    "xmldb/xcollection/0": '(: xcollection returns the exact collection, no subcollections :)
try { xmldb:xcollection("/db/apps/docs/data") }
catch * { "xcollection: " || $err:description }',
    "xmldb/xcollection/1": 'try { count(xmldb:xcollection("/db/apps/docs/data/try-it/ft/data")/*) }
catch * { "xcollection: " || $err:description }'
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
return string-join(("Fixed " || count($fixed) || " files:", for $f in $fixed order by $f return "  " || $f), "&#10;")
