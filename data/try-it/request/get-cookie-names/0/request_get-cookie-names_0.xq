(: request:get-cookie-names requires an HTTP request context :)
try { request:get-cookie-names() }
catch * { "request:get-cookie-names — " || $err:description }
