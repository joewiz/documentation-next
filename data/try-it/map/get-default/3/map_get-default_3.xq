let $map := map { "a": 1, "b": 2 }
let $key := "foo"
let $default := (1, "two", <three/>)
return
    map:get-default($map, $key, $default)