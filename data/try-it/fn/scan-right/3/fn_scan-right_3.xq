let $input := (1, 2, 3, 4, 5)
let $init := 0
let $action := function($item, $acc) { $acc + $item }
return
    scan-right($input, $init, $action)