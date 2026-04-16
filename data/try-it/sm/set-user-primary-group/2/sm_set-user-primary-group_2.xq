let $username := "hello"
let $group := "hello"
return
    sm:set-user-primary-group($username, $group)