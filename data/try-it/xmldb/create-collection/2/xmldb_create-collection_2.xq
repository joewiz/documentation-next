let $target-collection-uri := "hello"
let $new-collection := "hello"
return
    xmldb:create-collection($target-collection-uri, $new-collection)