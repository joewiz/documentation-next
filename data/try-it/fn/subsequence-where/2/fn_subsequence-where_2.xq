(: subsequence-where selects items starting from the first match :)
let $input := (1, 2, 3, 4, 5, 6)
let $from := function($n) { $n ge 3 }
return
    subsequence-where($input, $from)