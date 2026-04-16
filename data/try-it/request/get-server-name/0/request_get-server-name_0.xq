(: request:get-server-name requires an HTTP request context :)
try { request:get-server-name() }
catch * { "request:get-server-name — " || $err:description }
