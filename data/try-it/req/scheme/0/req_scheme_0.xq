(: Get the scheme of the HTTP request (e.g., http, https) :)
try { req:scheme() } catch * { "req:scheme#0 — " || $err:description }
