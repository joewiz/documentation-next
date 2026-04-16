let $input := (1, 2, 3, 4, 5)
let $subsequence := (2, 3)
let $compare := function($a, $b) { $a eq $b }
return
    contains-subsequence($input, $subsequence, $compare)