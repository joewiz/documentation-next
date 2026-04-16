let $data := map { "a": ("b","c"), "b": ("d",), "c": ("d",), "d": () }
let $input := "a"
let $step := function($item) { $data($item) }
return
    transitive-closure($input, $step)