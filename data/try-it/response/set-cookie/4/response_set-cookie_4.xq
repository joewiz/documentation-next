let $name := "hello"
let $value := "hello"
let $max-age := "example"
let $secure-flag := true()
return
    response:set-cookie($name, $value, $max-age, $secure-flag)