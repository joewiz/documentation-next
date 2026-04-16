let $source-collection-uri := "hello"
let $target-collection-uri := "hello"
return
    xmldb:copy-collection($source-collection-uri, $target-collection-uri)