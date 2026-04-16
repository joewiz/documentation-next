let $collection-uri := "hello"
let $directory := "hello"
let $pattern := "hello"
let $mime-type := "hello"
let $preserve-structure := true()
return
    xmldb:store-files-from-pattern($collection-uri, $directory, $pattern, $mime-type, $preserve-structure)