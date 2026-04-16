(: subsequence-where with start and end predicates :)
let $input := (1, 2, 3, 4, 5, 6)
let $from := function($n) { $n ge 2 }
let $to := function($n) { $n ge 5 }
return
    subsequence-where($input, $from, $to)