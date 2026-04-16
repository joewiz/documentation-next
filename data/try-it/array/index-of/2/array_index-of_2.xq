let $array := ["x", "y", "z"]
let $target := (1, "two", <three/>)
return
    array:index-of($array, $target)