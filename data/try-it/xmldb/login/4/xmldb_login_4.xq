let $collection-uri := "hello"
let $user-id := "hello"
let $password := "hello"
let $create-session := true()
return
    xmldb:login($collection-uri, $user-id, $password, $create-session)