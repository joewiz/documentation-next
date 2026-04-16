let $string := "hello"
let $trim := true()
return
    util:base64-encode($string, $trim)