(: Initialize an HTTP session if not already present :)
try { session:create(), "Session created" } catch * { "session:create#0 — " || $err:description }
