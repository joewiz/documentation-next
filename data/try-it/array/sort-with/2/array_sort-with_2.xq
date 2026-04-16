let $array := ["x", "y", "z"]
let $comparators := function($x) { $x }
return
    array:sort-with($array, $comparators)