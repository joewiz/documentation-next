let $array := [3, 1, 4, 1, 5]
let $comparator := function($a, $b) { if ($a lt $b) then -1 else if ($a gt $b) then 1 else 0 }
return
    array:sort-with($array, $comparator)