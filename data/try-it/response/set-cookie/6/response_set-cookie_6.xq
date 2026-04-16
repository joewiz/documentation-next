let $name := "hello"
let $value := "hello"
let $max-age := "example"
let $secure-flag := true()
let $domain := "hello"
let $path := "hello"
return
    response:set-cookie($name, $value, $max-age, $secure-flag, $domain, $path)