let $collection-uri := "hello"
let $doc-uri := "hello"
let $mode := "hello"
return
    xmldb:reindex($collection-uri, $doc-uri, $mode)