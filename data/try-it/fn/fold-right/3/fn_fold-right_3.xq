let $sequence := ("a", "b", "c")
let $zero := ""
let $function := function($item, $acc) { $acc || $item }
return
    fold-right($sequence, $zero, $function)