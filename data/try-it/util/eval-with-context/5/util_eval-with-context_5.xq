let $expression := "hello"
let $context := <item>value</item>
let $cache-flag := true()
let $eval-context-item := "hello"
let $pass := true()
return
    util:eval-with-context($expression, $context, $cache-flag, $eval-context-item, $pass)