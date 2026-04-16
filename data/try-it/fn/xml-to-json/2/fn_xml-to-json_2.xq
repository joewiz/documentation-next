let $node := <item>value</item>
let $options := map { "a": 1, "b": 2 }
return
    xml-to-json($node, $options)