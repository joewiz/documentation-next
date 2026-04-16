let $collection-uri := "hello"
let $resource := "hello"
return
    xmldb:document-has-lock($collection-uri, $resource)