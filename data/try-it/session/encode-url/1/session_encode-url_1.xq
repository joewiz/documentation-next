(: Encode a URL with the current session ID :)
try {
  session:encode-url(xs:anyURI("http://localhost:8080/exist/apps/docs"))
} catch * {
  "session:encode-url#1 — " || $err:description
}
