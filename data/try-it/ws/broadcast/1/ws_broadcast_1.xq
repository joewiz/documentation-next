import module namespace ws = "http://exist-db.org/xquery/websocket";

(: Broadcast a message to all connected WebSocket clients :)
let $_ := ws:broadcast("Broadcast from try-it at " || current-dateTime())
return "ws:broadcast#1 — sent message to all connected clients"
