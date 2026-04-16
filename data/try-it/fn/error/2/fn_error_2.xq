let $code := xs:QName("fn:concat")
let $description := "hello"
return
    error($code, $description)