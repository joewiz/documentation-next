let $input := (1, 2, 3, 4, 5)
let $subsequence := (4, 5)
let $compare := function($a, $b) { $a eq $b }
return
    ends-with-subsequence($input, $subsequence, $compare)