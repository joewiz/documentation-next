(: List all attribute names in the current session :)
try {
  let $names := session:get-attribute-names()
  return
    if (exists($names)) then $names
    else "No attributes in session"
} catch * {
  "session:get-attribute-names#0 — " || $err:description
}
