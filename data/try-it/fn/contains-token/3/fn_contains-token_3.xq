let $value := '("hello", "world")'
let $token := "hello"
let $collation := "hello"
return
    contains-token($value, $token, $collation)