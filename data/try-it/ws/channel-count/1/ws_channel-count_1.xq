import module namespace ws = "http://exist-db.org/xquery/websocket";

(: Check how many clients are subscribed to a channel :)
map {
    "default-channel": ws:channel-count("default"),
    "updates-channel": ws:channel-count("updates")
}
