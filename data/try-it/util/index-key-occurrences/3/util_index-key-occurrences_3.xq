let $nodes := <item>value</item>
let $value := "example"
let $index := "hello"
return
    util:index-key-occurrences($nodes, $value, $index)