(: request:get-query-string requires an HTTP request context :)
try { request:get-query-string() }
catch * { "request:get-query-string — " || $err:description }
