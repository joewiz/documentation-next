let $expression := "hello"
let $cache-flag := true()
return
    util:eval($expression, $cache-flag)