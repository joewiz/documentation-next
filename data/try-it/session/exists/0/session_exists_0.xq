(: Check whether an HTTP session exists :)
try { session:exists() } catch * { "session:exists#0 — " || $err:description }
