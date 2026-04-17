(: Get the time when the session was created :)
try { session:get-creation-time() } catch * { "session:get-creation-time#0 — " || $err:description }
