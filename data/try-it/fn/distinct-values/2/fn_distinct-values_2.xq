let $values := ("apple", "APPLE", "Apple")
let $collation := "http://www.w3.org/2013/collation/UCA?strength=secondary"
return
    distinct-values($values, $collation)