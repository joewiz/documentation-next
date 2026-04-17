(: Send a JSON message to a console channel :)
import module namespace console = "http://exist-db.org/xquery/console";

let $_ := console:send("demo", map { "event": "test", "timestamp": current-dateTime() })
return
  "Sent JSON message to 'demo' channel"
