(: request:attribute-names requires an HTTP request context :)
try { request:attribute-names() }
catch * { "request:attribute-names — " || $err:description }
