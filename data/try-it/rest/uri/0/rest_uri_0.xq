(: Get the complete URI that addressed the current RESTXQ resource function :)
try {
  rest:uri()
} catch * {
  "rest:uri#0 — requires RESTXQ context; " || $err:description
}
