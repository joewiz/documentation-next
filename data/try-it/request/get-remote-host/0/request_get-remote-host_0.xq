(: request:get-remote-host requires an HTTP request context :)
try { request:get-remote-host() }
catch * { "request:get-remote-host — " || $err:description }
