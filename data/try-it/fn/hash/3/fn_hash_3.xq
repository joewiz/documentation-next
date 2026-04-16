let $value := "Hello, World!"
let $algorithm := "SHA-256"
let $options := map { "encoding": "hex" }
return
    hash($value, $algorithm, $options)