let $map := map { "a": 1, "b": 2, "c": 3 }
let $predicate := function($k, $v) { $v mod 2 eq 0 }
return
    map:keys-where($map, $predicate)