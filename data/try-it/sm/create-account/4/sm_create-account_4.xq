let $username := "hello"
let $password := "hello"
let $primary-group := "hello"
let $groups := "hello"
return
    sm:create-account($username, $password, $primary-group, $groups)