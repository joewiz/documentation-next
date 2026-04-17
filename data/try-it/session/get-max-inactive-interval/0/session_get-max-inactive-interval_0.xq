(: Get the max inactive interval (seconds) before session timeout :)
try { session:get-max-inactive-interval() } catch * { "session:get-max-inactive-interval#0 — " || $err:description }
