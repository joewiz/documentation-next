(: Get the path component of the HTTP request URI :)
try { req:path() } catch * { "req:path#0 — " || $err:description }
