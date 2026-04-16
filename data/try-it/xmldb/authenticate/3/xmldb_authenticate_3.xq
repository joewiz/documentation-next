let $collection-uri := "hello"
let $user-id := "hello"
let $password := "hello"
return
    xmldb:authenticate($collection-uri, $user-id, $password)