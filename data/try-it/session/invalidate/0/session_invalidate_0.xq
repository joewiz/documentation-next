(: Invalidate (remove) the current HTTP session :)
try { session:invalidate(), "Session invalidated" } catch * { "session:invalidate#0 — " || $err:description }
