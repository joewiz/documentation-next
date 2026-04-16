let $collection-uri := "hello"
let $resource-name := "hello"
let $contents := "hello"
return
    xmldb:store($collection-uri, $resource-name, $contents)