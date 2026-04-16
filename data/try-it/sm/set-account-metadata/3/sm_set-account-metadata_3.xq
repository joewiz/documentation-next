let $username := "hello"
let $attribute := "/db/apps/docs"
let $value := "hello"
return
    sm:set-account-metadata($username, $attribute, $value)