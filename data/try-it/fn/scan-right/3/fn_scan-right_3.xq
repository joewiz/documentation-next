let $input := (1, "two", <three/>)
let $init := (1, "two", <three/>)
let $action := function($x) { $x }
return
    scan-right($input, $init, $action)