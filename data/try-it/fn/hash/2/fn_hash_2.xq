let $value := "Hello, World!"
let $algorithm := "SHA-256"
return
    hash($value, $algorithm)