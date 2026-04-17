(: Send an HTTP POST with a body as the third parameter :)
(: The 3-arg form separates request descriptor, URI, and body :)
import module namespace http = "http://expath.org/ns/http-client";

try {
  let $body :=
    <query xmlns="http://exist.sourceforge.net/NS/exist">
      <text><![CDATA[<result>{current-dateTime()}</result>]]></text>
    </query>
  let $response := http:send-request(
    <http:request method="POST">
      <http:body media-type="application/xml"/>
    </http:request>,
    "http://localhost:8080/exist/rest/db",
    $body
  )
  return
    <result>
      <status>{$response[1]/@status/string()}</status>
      <body>{$response[2]}</body>
    </result>
} catch * {
  "http:send-request#3 — " || $err:description
}
