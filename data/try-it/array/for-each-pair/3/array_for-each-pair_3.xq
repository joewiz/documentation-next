let $array1 := [1, 2, 3]
let $array2 := [10, 20, 30]
let $action := function($a, $b) { $a + $b }
return
    array:for-each-pair($array1, $array2, $action)