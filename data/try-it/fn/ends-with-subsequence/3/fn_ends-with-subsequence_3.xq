let $input := (1, "two", <three/>)
let $subsequence := (1, "two", <three/>)
let $compare := function($x) { $x }
return
    ends-with-subsequence($input, $subsequence, $compare)