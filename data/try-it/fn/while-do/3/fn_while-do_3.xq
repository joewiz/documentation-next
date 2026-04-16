let $input := (1, "two", <three/>)
let $predicate := function($x) { $x }
let $action := function($x) { $x }
return
    while-do($input, $predicate, $action)