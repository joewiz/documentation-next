import module namespace ws = "http://exist-db.org/xquery/websocket";

(: Send a JSON message to a named WebSocket channel :)
let $_ := ws:send("updates", map {
    "type": "notification",
    "message": "Hello from XQuery",
    "timestamp": current-dateTime()
})
return "ws:send#2 — sent JSON message to the 'updates' channel"
