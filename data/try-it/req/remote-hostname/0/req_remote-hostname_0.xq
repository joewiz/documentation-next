(: Get the hostname of the client that sent the request :)
try { req:remote-hostname() } catch * { "req:remote-hostname#0 — " || $err:description }
