let $value := "hello"
let $algorithm := "hello"
let $options := map { "a": 1, "b": 2 }
return
    hash($value, $algorithm, $options)