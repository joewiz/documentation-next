(: Get the last time the client accessed the session :)
try { session:get-last-accessed-time() } catch * { "session:get-last-accessed-time#0 — " || $err:description }
