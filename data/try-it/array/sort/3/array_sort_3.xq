let $array := [map{"name":"Charlie","age":30}, map{"name":"Alice","age":25}, map{"name":"Bob","age":35}]
let $collation := ()
let $key := function($m) { $m?age }
return
    array:sort($array, $collation, $key)