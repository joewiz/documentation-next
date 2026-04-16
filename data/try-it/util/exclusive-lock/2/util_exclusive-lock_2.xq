let $nodes := <item>value</item>
let $expression := "hello"
return
    util:exclusive-lock($nodes, $expression)