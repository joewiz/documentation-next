(: List missing dependencies discovered by RESTXQ during resource function discovery :)
try {
  exrest:missing-dependencies()
} catch * {
  "exrest:missing-dependencies#0 — " || $err:description
}
