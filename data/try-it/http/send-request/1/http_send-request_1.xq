(: Send an HTTP GET request with the URI in the request element :)
import module namespace http = "http://expath.org/ns/http-client";

let $response := http:send-request(
  <http:request method="GET"
    href="http://localhost:8080/exist/rest/db"/>
)
let $status := $response[1]
return
  <result>
    <status>{$status/@status/string()}</status>
    <message>{$status/@message/string()}</message>
    <content-type>
      {$status/http:header[@name = "Content-Type"]/@value/string()}
    </content-type>
  </result>
