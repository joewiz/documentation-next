let $username := "hello"
let $attribute := "/db/apps/docs"
return
    sm:get-account-metadata($username, $attribute)