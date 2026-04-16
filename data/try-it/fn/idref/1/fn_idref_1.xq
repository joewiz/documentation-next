(: idref() requires context with IDREF attributes :)
let $doc := <root><item xml:id="a1">First</item></root>
return
    count($doc//item)