(: request:get-hostname requires an HTTP request context :)
try { request:get-hostname() }
catch * { "request:get-hostname — " || $err:description }
