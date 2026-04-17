(: Get the query string from the HTTP request URI :)
try {
  let $q := req:query()
  return if (exists($q)) then $q else "No query string"
} catch * {
  "req:query#0 — " || $err:description
}
