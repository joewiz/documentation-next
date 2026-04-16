let $input := (3, 1, 4, 1, 5, 9)
let $comparator := function($a, $b) { if ($a lt $b) then -1 else if ($a gt $b) then 1 else 0 }
return
    sort-with($input, $comparator)