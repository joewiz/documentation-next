(: Get the value of a named request parameter :)
try {
  let $val := req:parameter("query")
  return if (exists($val)) then $val else "No 'query' parameter"
} catch * {
  "req:parameter#1 — " || $err:description
}
