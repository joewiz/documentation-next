import module namespace ws = "http://exist-db.org/xquery/websocket";

(: Log a message to the default WebSocket channel :)
let $_ := ws:log("Hello from try-it at " || current-dateTime())
return "ws:log#1 — sent message to the default channel (open browser console/WebSocket client to see it)"
