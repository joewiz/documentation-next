let $node := <test xmlns:foo="http://example.com"><foo:bar>hello</foo:bar></test>
return util:expand($node, "expand-xincludes=no")