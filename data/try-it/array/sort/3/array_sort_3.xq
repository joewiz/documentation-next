let $array := ["x", "y", "z"]
let $collation := "hello"
let $key := function($x) { $x }
return
    array:sort($array, $collation, $key)