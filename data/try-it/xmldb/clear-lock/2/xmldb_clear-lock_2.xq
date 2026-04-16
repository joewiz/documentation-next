let $collection-uri := "hello"
let $resource := "hello"
return
    xmldb:clear-lock($collection-uri, $resource)