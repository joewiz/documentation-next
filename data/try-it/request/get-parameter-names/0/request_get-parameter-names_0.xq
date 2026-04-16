(: request:get-parameter-names requires an HTTP request context :)
try { request:get-parameter-names() }
catch * { "request:get-parameter-names — " || $err:description }
