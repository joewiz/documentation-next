let $node-set := <item>value</item>
let $since := "example"
return
    xmldb:find-last-modified-since($node-set, $since)