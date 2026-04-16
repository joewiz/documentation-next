let $items-1 := (1, 2, 3)
let $items-2 := (1, 2, 3)
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    deep-equal($items-1, $items-2, $collation)