let $map := map { "a": 1, "b": 2 }
let $key := "foo"
return
    map:get($map, $key)