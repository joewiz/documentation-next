let $input := (1, "two", <three/>)
let $step := function($x) { $x }
return
    transitive-closure($input, $step)