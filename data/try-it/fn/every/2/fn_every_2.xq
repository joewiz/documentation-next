let $input := (2, 4, 6, 8)
let $predicate := function($n) { $n mod 2 = 0 }
return
    every($input, $predicate)