let $function-reference := function($x) { $x }
let $parameters := "hello"
return
    util:call($function-reference, $parameters)