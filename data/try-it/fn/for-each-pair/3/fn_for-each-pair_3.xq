let $seq1 := (1, "two", <three/>)
let $seq2 := (1, "two", <three/>)
let $function := function($x) { $x }
return
    for-each-pair($seq1, $seq2, $function)