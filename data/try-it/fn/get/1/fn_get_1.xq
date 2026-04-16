(: fn:get retrieves from the dynamic context map :)
let $map := map { "x": 42, "y": 99 }
return
    $map?x