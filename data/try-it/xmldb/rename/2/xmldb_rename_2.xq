let $source-collection-uri := "hello"
let $new-collection-name := "hello"
return
    xmldb:rename($source-collection-uri, $new-collection-name)