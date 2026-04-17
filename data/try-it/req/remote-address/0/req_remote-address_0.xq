(: Get the IP address of the client that sent the request :)
try { req:remote-address() } catch * { "req:remote-address#0 — " || $err:description }
