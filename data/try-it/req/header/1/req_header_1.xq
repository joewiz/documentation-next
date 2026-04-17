(: Get the value of a named HTTP header :)
try {
  let $val := req:header("User-Agent")
  return if (exists($val)) then $val else "No User-Agent header"
} catch * {
  "req:header#1 — " || $err:description
}
