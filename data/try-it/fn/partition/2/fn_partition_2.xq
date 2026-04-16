let $input := (1, "two", <three/>)
let $split-when := function($x) { $x }
return
    partition($input, $split-when)