let $array := ["x", "y", "z"]
let $keys := map { "a": 1, "b": 2 }
return
    array:sort-by($array, $keys)