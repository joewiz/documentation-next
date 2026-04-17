(: List all dependencies of compiled XQuery modules discovered by RESTXQ :)
try {
  exrest:dependencies()
} catch * {
  "exrest:dependencies#0 — " || $err:description
}
