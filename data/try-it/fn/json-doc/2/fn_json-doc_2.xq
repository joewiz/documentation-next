let $source := "hello"
let $options := map { "a": 1, "b": 2 }
return
    json-doc($source, $options)