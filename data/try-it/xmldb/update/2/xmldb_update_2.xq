let $collection-uri := "hello"
let $modifications := <item>value</item>
return
    xmldb:update($collection-uri, $modifications)