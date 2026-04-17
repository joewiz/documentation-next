(: Get an HTTP header with a default value :)
try {
  req:header("X-Custom-Header", "not-present")
} catch * {
  "req:header#2 — " || $err:description
}
