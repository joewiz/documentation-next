let $input := (1, 2, 3, 4, 5)
let $subsequence := (1, 2)
let $compare := function($a, $b) { $a eq $b }
return
    starts-with-subsequence($input, $subsequence, $compare)