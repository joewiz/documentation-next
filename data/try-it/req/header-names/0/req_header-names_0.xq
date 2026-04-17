(: Get the names of all HTTP headers in the request :)
try { req:header-names() } catch * { "req:header-names#0 — " || $err:description }
