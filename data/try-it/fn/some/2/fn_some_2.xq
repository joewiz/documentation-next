let $input := (1, "two", <three/>)
let $predicate := function($x) { $x }
return
    some($input, $predicate)