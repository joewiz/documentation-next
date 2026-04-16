(: id() requires a document with xml:id attributes :)
let $doc := <root><item xml:id="a1">First</item><item xml:id="b2">Second</item></root>
return
    $doc/id("b2")/string()