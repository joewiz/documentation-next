let $map := map { "a": 1, "b": 2 }
let $key := "foo"
let $value := (1, "two", <three/>)
return
    map:put($map, $key, $value)