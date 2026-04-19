import module namespace ws = "http://exist-db.org/xquery/websocket";

(: Log a message to a named WebSocket channel :)
let $_ := ws:log("debug", "Debug info: query executed at " || current-dateTime())
return "ws:log#2 — sent message to the 'debug' channel"
