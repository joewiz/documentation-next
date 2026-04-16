let $expression := "hello"
let $cache-flag := true()
let $external-variable := "example"
let $pass := true()
return
    util:eval($expression, $cache-flag, $external-variable, $pass)