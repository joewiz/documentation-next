(: request:is-multipart-content requires an HTTP request context :)
try { request:is-multipart-content() }
catch * { "request:is-multipart-content — " || $err:description }
