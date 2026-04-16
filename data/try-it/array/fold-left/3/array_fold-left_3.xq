let $array := ["a", "b", "c"]
let $zero := ""
let $function := function($acc, $item) { $acc || $item }
return
    array:fold-left($array, $zero, $function)