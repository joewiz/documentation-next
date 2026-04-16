let $map := map { "a": 1, "b": 2, "c": 3 }
let $predicate := function($k, $v) { $v > 1 }
return
    map:filter($map, $predicate)