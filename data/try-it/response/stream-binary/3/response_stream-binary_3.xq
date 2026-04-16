let $binary-data := "example"
let $content-type := "hello"
let $filename := "hello"
return
    response:stream-binary($binary-data, $content-type, $filename)