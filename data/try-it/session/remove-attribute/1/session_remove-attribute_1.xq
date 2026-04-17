(: Remove a named attribute from the session :)
try {
  session:remove-attribute("demo-key"),
  "Attribute 'demo-key' removed"
} catch * {
  "session:remove-attribute#1 — " || $err:description
}
