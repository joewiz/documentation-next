let $username := "hello"
let $password := "hello"
let $primary-group := "hello"
let $groups := "hello"
let $full-name := "hello"
let $description := "hello"
return
    sm:create-account($username, $password, $primary-group, $groups, $full-name, $description)