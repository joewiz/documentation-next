(: Get the hostname from the HTTP request URI :)
try { req:hostname() } catch * { "req:hostname#0 — " || $err:description }
