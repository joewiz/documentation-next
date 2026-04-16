let $map := map { "a": 1, "b": 2 }
let $key := "foo"
return
    map:contains($map, $key)