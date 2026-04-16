let $name := "hello"
let $default-value := "hello"
let $failonerror := true()
return
    request:get-parameter($name, $default-value, $failonerror)