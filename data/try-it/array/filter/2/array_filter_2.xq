let $array := ["x", "y", "z"]
let $action := function($x) { $x }
return
    array:filter($array, $action)