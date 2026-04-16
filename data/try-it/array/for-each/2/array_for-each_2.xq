let $array := ["x", "y", "z"]
let $action := function($x) { $x }
return
    array:for-each($array, $action)