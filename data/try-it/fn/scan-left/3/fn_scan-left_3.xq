let $input := (1, "two", <three/>)
let $init := (1, "two", <three/>)
let $action := function($x) { $x }
return
    scan-left($input, $init, $action)