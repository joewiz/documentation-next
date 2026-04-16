let $escaped-string := "hello"
let $encoding := "hello"
return
    util:unescape-uri($escaped-string, $encoding)