(: partial-apply binds arguments to a function :)
let $add := function($a, $b) { $a + $b }
let $add10 := partial-apply($add, map { 1: 10 })
return
    $add10(32)