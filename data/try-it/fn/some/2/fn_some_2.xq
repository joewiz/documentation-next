let $input := (1, 3, 5, 8, 9)
let $predicate := function($n) { $n mod 2 = 0 }
return
    some($input, $predicate)