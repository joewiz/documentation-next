(: transitive-closure finds all reachable nodes :)
let $graph :=
    map {
        "a": ("b", "c"),
        "b": ("d"),
        "c": ("d"),
        "d": ()
    }
let $step := function($node) { $graph($node) }
return
    transitive-closure("a", $step)