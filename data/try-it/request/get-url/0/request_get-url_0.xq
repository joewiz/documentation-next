(: request:get-url requires an HTTP request context :)
try { request:get-url() }
catch * { "request:get-url — " || $err:description }
