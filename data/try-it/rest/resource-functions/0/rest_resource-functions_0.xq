(: List all registered RESTXQ resource functions :)
try {
  rest:resource-functions()
} catch * {
  "rest:resource-functions#0 — requires RESTXQ context; " || $err:description
}
