(: declare-namespace requires a side-effect context :)
try { util:declare-namespace("foo", xs:anyURI("http://example.com/foo")) }
catch * { "declare-namespace: " || $err:description }