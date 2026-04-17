(: Get the full URI of the HTTP request :)
try { req:uri() } catch * { "req:uri#0 — " || $err:description }
