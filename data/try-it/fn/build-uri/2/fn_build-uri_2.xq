let $parts := map { "a": 1, "b": 2 }
let $options := map { "a": 1, "b": 2 }
return
    build-uri($parts, $options)