let $input := (1, "two", <three/>)
let $comparators := function($x) { $x }
return
    sort-with($input, $comparators)