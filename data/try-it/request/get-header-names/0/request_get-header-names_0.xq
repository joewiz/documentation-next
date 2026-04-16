(: request:get-header-names requires an HTTP request context :)
try { request:get-header-names() }
catch * { "request:get-header-names — " || $err:description }
