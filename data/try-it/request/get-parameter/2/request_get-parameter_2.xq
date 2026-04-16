let $name := "hello"
let $default-value := "hello"
return
    request:get-parameter($name, $default-value)