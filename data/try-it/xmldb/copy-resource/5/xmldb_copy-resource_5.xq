let $source-collection-uri := "hello"
let $source-resource-name := "hello"
let $target-collection-uri := "hello"
let $target-resource-name := "hello"
let $preserve := true()
return
    xmldb:copy-resource($source-collection-uri, $source-resource-name, $target-collection-uri, $target-resource-name, $preserve)