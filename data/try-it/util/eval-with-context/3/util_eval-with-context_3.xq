let $expression := "hello"
let $context := <item>value</item>
let $cache-flag := true()
return
    util:eval-with-context($expression, $context, $cache-flag)