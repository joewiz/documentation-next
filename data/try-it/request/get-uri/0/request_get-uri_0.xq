(: request:get-uri requires an HTTP request context :)
try { request:get-uri() }
catch * { "request:get-uri — " || $err:description }
