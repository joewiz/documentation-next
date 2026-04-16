let $xquery-id := 42
let $wait-time := "example"
return
    system:kill-running-xquery($xquery-id, $wait-time)