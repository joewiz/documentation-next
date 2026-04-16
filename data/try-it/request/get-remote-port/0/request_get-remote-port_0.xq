(: request:get-remote-port requires an HTTP request context :)
try { request:get-remote-port() }
catch * { "request:get-remote-port — " || $err:description }
