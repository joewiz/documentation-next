let $input := ("apple", "banana", "cherry")
let $key := function($s) { substring($s, 1, 1) }
let $value := function($s) { upper-case($s) }
return
    map:build($input, $key, $value)