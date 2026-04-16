let $message := "hello"
let $algorithm := "hello"
let $base64flag := true()
return
    util:hash($message, $algorithm, $base64flag)