let $input := (1, 2, 3, 4, 5)
let $init := 0
let $action := function($acc, $item) { $acc + $item }
return
    scan-left($input, $init, $action)