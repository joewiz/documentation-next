let $collection-uri := "hello"
let $resource := "hello"
return
    xmldb:last-modified($collection-uri, $resource)