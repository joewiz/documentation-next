let $array := ["banana", "apple", "cherry"]
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    array:sort($array, $collation)