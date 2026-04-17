(: Send an HTTP request with the URI as a separate parameter :)
import module namespace http = "http://expath.org/ns/http-client";

let $response := http:send-request(
  <http:request method="GET">
    <http:header name="Accept" value="application/xml"/>
  </http:request>,
  "http://localhost:8080/exist/rest/db?_query=current-dateTime()"
)
let $status := $response[1]
let $body := $response[2]
return
  <result>
    <status>{$status/@status/string()}</status>
    <body>{$body}</body>
  </result>
