(: Get the current session ID :)
try { session:get-id() } catch * { "session:get-id#0 — " || $err:description }
