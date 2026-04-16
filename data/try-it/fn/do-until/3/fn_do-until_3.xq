let $input := 1
let $action := function($n) { $n * 2 }
let $predicate := function($n) { $n > 100 }
return
    do-until($input, $action, $predicate)