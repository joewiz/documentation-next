(: request:get-server-port requires an HTTP request context :)
try { request:get-server-port() }
catch * { "request:get-server-port — " || $err:description }
