(: element-with-id needs an XML document with ID attributes :)
let $doc := <root><item xml:id="a1">First</item><item xml:id="b2">Second</item></root>
return
    $doc/id("a1")/string()