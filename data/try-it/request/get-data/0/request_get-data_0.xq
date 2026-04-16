(: request:get-data requires an HTTP request context :)
try { request:get-data() }
catch * { "request:get-data — " || $err:description }
