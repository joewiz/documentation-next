(: request:get-method requires an HTTP request context :)
try { request:get-method() }
catch * { "request:get-method — " || $err:description }
