let $input := (1, "two", <three/>)
let $action := function($x) { $x }
return
    array:build($input, $action)