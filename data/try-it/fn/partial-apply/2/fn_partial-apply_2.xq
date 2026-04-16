let $function := function($x) { $x }
let $arguments := map { "a": 1, "b": 2 }
return
    partial-apply($function, $arguments)