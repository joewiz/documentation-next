let $source-collection-uri := "hello"
let $target-collection-uri := "hello"
return
    xmldb:move($source-collection-uri, $target-collection-uri)