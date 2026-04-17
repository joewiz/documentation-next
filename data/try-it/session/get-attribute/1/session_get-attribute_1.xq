(: Retrieve a named attribute from the session :)
try {
  let $val := session:get-attribute("demo-key")
  return if (exists($val)) then $val else "No attribute 'demo-key' in session"
} catch * {
  "session:get-attribute#1 — " || $err:description
}
