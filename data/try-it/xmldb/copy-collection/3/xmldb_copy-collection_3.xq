let $source-collection-uri := "hello"
let $target-collection-uri := "hello"
let $preserve := true()
return
    xmldb:copy-collection($source-collection-uri, $target-collection-uri, $preserve)