let $input := (1, "two", <three/>)
let $from := function($x) { $x }
return
    subsequence-where($input, $from)