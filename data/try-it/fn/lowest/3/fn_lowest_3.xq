let $input := ("banana", "apple", "cherry")
let $collation := ()
let $key := function($s) { string-length($s) }
return
    lowest($input, $collation, $key)