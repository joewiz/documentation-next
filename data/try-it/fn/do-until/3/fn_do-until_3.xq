let $input := (1, "two", <three/>)
let $action := function($x) { $x }
let $predicate := function($x) { $x }
return
    do-until($input, $action, $predicate)