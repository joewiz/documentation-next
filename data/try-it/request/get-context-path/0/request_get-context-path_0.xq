(: request:get-context-path requires an HTTP request context :)
try { request:get-context-path() }
catch * { "request:get-context-path — " || $err:description }
