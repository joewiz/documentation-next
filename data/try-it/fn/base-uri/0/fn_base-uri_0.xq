(: base-uri#0 requires a context node; use base-uri#1 instead :)
let $node := <test xml:base="http://example.com/doc"/>
return
    base-uri($node)