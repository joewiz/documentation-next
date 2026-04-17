(: Get the value of a named cookie :)
try {
  let $val := req:cookie("JSESSIONID")
  return if (exists($val)) then $val else "No JSESSIONID cookie"
} catch * {
  "req:cookie#1 — " || $err:description
}
