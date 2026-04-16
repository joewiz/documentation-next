let $nodes := <item>value</item>
let $expression := "hello"
return
    util:shared-lock($nodes, $expression)