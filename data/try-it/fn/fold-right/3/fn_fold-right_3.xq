let $sequence := (1, "two", <three/>)
let $zero := (1, "two", <three/>)
let $function := function($x) { $x }
return
    fold-right($sequence, $zero, $function)