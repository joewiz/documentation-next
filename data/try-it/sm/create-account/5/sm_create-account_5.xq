let $username := "hello"
let $password := "hello"
let $groups := "hello"
let $full-name := "hello"
let $description := "hello"
return
    sm:create-account($username, $password, $groups, $full-name, $description)