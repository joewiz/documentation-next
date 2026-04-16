let $name := "hello"
let $value := "hello"
return
    response:set-header($name, $value)