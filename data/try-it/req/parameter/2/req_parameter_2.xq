(: Get a request parameter with a default value :)
try {
  req:parameter("missing-param", "default-value")
} catch * {
  "req:parameter#2 — " || $err:description
}
