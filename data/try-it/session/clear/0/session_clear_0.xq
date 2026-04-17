(: Remove all attributes from the current session without invalidating it :)
try { session:clear(), "Session cleared" } catch * { "session:clear#0 — " || $err:description }
