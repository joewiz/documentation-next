let $values := '("hello", "world")'
let $node := <item>value</item>
return
    idref($values, $node)