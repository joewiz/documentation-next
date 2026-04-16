let $input := (1, "two", <three/>)
let $collation := "hello"
let $key := function($x) { $x }
return
    lowest($input, $collation, $key)