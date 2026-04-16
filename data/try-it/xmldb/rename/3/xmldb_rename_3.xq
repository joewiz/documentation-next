let $collection-uri := "hello"
let $resource := "hello"
let $new-resource-name := "hello"
return
    xmldb:rename($collection-uri, $resource, $new-resource-name)