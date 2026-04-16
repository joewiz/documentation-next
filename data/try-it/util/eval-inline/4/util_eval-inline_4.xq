let $inline-context := "hello"
let $expression := "hello"
let $cache-flag := true()
let $pass := true()
return
    util:eval-inline($inline-context, $expression, $cache-flag, $pass)