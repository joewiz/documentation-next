let $nodes := <item>value</item>
let $value := "example"
return
    util:index-key-occurrences($nodes, $value)