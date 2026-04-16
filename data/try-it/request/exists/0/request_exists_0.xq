(: request:exists requires an HTTP request context :)
try { request:exists() }
catch * { "request:exists — " || $err:description }
