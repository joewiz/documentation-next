(: Store a value in the session by attribute name :)
try {
  session:set-attribute("demo-key", "Hello from try-it!"),
  "Attribute 'demo-key' set in session"
} catch * {
  "session:set-attribute#2 — " || $err:description
}
