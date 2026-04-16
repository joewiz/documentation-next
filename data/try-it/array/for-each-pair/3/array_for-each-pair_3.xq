let $array := ["x", "y", "z"]
let $array2 := ["x", "y", "z"]
let $action := function($x) { $x }
return
    array:for-each-pair($array, $array2, $action)