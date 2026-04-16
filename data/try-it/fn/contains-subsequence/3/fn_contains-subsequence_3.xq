let $input := (1, "two", <three/>)
let $subsequence := (1, "two", <three/>)
let $compare := function($x) { $x }
return
    contains-subsequence($input, $subsequence, $compare)