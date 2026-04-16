let $uri := "hello"
let $options := map { "a": 1, "b": 2 }
return
    csv-doc($uri, $options)