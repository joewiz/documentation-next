let $input := ("banana", "fig", "apple", "cherry")
let $keys := function($s) { string-length($s) }
return
    sort-by($input, $keys)