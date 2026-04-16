let $node-set := <item>value</item>
let $until := "example"
return
    xmldb:find-last-modified-until($node-set, $until)