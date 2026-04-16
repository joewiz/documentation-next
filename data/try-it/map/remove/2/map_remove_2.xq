let $map := map { "a": 1, "b": 2 }
let $keys := "foo"
return
    map:remove($map, $keys)