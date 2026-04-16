let $input := ("apple", "banana", "cherry")
let $key := function($s) { substring($s, 1, 1) }
return
    map:build($input, $key)