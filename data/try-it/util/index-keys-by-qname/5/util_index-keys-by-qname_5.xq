let $qname := xs:QName("fn:concat")
let $start-value := "example"
let $function-reference := function($x) { $x }
let $max-number-returned := 42
let $index := "hello"
return
    util:index-keys-by-qname($qname, $start-value, $function-reference, $max-number-returned, $index)