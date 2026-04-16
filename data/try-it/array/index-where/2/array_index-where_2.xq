let $array := ["x", "y", "z"]
let $predicate := function($x) { $x }
return
    array:index-where($array, $predicate)