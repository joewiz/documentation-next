let $input := ("apple", "APPLE", "Apple")
let $target := "apple"
let $collation := "http://www.w3.org/2013/collation/UCA?strength=secondary"
return
    index-of($input, $target, $collation)