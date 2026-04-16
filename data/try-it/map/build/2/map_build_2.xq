let $input := (1, "two", <three/>)
let $key := function($x) { $x }
return
    map:build($input, $key)