(: request:get-servlet-path requires an HTTP request context :)
try { request:get-servlet-path() }
catch * { "request:get-servlet-path — " || $err:description }
