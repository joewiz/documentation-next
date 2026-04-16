let $input := (1, "two", <three/>)
let $predicate := function($x) { $x }
return
    every($input, $predicate)