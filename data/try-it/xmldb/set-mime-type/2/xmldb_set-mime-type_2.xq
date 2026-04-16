let $resource-uri := "/db/apps/docs"
let $mime-type := "hello"
return
    xmldb:set-mime-type($resource-uri, $mime-type)