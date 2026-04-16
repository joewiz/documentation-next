let $collection-uri := "hello"
let $resource := "hello"
let $modification-time := "example"
return
    xmldb:touch($collection-uri, $resource, $modification-time)