let $node-set := <item>value</item>
let $start-value := "example"
let $function-reference := function($x) { $x }
let $max-number-returned := 42
let $index := "hello"
return
    util:index-keys($node-set, $start-value, $function-reference, $max-number-returned, $index)