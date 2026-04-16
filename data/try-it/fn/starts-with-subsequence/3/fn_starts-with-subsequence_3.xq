let $input := (1, "two", <three/>)
let $subsequence := (1, "two", <three/>)
let $compare := function($x) { $x }
return
    starts-with-subsequence($input, $subsequence, $compare)