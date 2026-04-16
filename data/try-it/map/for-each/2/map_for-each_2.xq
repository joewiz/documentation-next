let $map := map { "x": 10, "y": 20, "z": 30 }
let $action := function($k, $v) { $k || "=" || $v }
return
    map:for-each($map, $action)