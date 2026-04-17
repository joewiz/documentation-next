(: Get the TCP port of the client socket :)
try { req:remote-port() } catch * { "req:remote-port#0 — " || $err:description }
