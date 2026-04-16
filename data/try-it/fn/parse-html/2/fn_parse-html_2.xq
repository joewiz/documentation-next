let $value := "hello"
let $options := map { "a": 1, "b": 2 }
return
    parse-html($value, $options)