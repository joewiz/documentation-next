let $input := (1, "two", <three/>)
let $keys := map { "a": 1, "b": 2 }
return
    sort-by($input, $keys)