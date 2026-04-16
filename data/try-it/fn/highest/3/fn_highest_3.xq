let $input := (1, "two", <three/>)
let $collation := "hello"
let $key := function($x) { $x }
return
    highest($input, $collation, $key)