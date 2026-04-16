let $array := [1, 2, 3, 4, 5]
let $zero := 0
let $function := function($item, $acc) { $acc + $item }
return
    array:fold-right($array, $zero, $function)