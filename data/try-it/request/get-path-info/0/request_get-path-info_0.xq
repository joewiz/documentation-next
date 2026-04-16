(: request:get-path-info requires an HTTP request context :)
try { request:get-path-info() }
catch * { "request:get-path-info — " || $err:description }
