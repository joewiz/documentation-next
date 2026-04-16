let $expression := "hello"
let $cache-flag := true()
let $external-variable := "example"
return
    util:eval($expression, $cache-flag, $external-variable)