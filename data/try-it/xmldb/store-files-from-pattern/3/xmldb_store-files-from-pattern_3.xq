let $collection-uri := "hello"
let $directory := "hello"
let $pattern := "hello"
return
    xmldb:store-files-from-pattern($collection-uri, $directory, $pattern)