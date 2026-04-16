let $collection-uri := "hello"
let $resource-name := "hello"
let $contents := "hello"
let $mime-type := "hello"
return
    xmldb:store($collection-uri, $resource-name, $contents, $mime-type)