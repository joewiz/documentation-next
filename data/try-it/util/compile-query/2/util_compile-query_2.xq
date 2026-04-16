let $expression := "hello"
let $module-load-path := "hello"
return
    util:compile-query($expression, $module-load-path)