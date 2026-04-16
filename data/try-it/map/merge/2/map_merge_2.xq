let $maps := map { "a": 1, "b": 2 }
let $options := map { "a": 1, "b": 2 }
return
    map:merge($maps, $options)