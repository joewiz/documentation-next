let $array := ["x", "y", "z"]
let $zero := (1, "two", <three/>)
let $function := function($x) { $x }
return
    array:fold-right($array, $zero, $function)