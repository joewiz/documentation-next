(: request:get-scheme requires an HTTP request context :)
try { request:get-scheme() }
catch * { "request:get-scheme — " || $err:description }
