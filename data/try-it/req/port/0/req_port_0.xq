(: Get the port from the HTTP request URI :)
try { req:port() } catch * { "req:port#0 — " || $err:description }
