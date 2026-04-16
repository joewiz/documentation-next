let $map := map { "a": 1, "b": 2 }
let $action := function($x) { $x }
return
    map:for-each($map, $action)