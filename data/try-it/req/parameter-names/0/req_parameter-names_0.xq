(: Get the names of all parameters in the HTTP request :)
try {
  let $names := req:parameter-names()
  return if (exists($names)) then $names else "No parameters"
} catch * {
  "req:parameter-names#0 — " || $err:description
}
