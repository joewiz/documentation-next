(: Get the IP address of the server that received the request :)
try { req:address() } catch * { "req:address#0 — " || $err:description }
