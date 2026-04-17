(: Get the base URI of the current RESTXQ resource function :)
try {
  rest:base-uri()
} catch * {
  "rest:base-uri#0 — requires RESTXQ context; " || $err:description
}
