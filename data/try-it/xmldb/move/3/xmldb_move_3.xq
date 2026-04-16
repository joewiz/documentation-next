let $source-collection-uri := "hello"
let $target-collection-uri := "hello"
let $resource := "hello"
return
    xmldb:move($source-collection-uri, $target-collection-uri, $resource)