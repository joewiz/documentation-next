let $username := "hello"
let $enabled := true()
return
    sm:set-account-enabled($username, $enabled)