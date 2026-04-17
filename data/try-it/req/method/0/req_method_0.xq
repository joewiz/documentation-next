(: Get the HTTP method of the request (e.g., GET, POST) :)
try { req:method() } catch * { "req:method#0 — " || $err:description }
