let $nodes := <item>value</item>
let $value := "example"
let $index := "hello"
return
    util:index-key-documents($nodes, $value, $index)