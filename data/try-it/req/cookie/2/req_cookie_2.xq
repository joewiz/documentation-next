(: Get a cookie with a default value :)
try {
  req:cookie("missing-cookie", "default-value")
} catch * {
  "req:cookie#2 — " || $err:description
}
