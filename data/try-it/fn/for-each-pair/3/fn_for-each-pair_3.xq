let $seq1 := (1, 2, 3)
let $seq2 := (10, 20, 30)
let $function := function($a, $b) { $a * $b }
return
    for-each-pair($seq1, $seq2, $function)