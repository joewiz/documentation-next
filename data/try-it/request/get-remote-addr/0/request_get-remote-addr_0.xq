(: request:get-remote-addr requires an HTTP request context :)
try { request:get-remote-addr() }
catch * { "request:get-remote-addr — " || $err:description }
