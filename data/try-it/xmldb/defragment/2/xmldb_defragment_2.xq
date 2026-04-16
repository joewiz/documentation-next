let $nodes := <item>value</item>
let $integer := 42
return
    xmldb:defragment($nodes, $integer)