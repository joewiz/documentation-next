let $map := map { "a": 1, "b": 2 }
let $predicate := function($x) { $x }
return
    map:filter($map, $predicate)