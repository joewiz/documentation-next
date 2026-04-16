let $input := 1
let $predicate := function($n) { $n lt 100 }
let $action := function($n) { $n * 2 }
return
    while-do($input, $predicate, $action)