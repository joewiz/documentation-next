let $grammar := "hello"
let $options := map { "a": 1, "b": 2 }
return
    invisible-xml($grammar, $options)