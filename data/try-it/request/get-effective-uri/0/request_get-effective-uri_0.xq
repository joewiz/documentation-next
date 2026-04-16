(: request:get-effective-uri requires an HTTP request context :)
try { request:get-effective-uri() }
catch * { "request:get-effective-uri — " || $err:description }
