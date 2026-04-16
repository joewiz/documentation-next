let $code := xs:QName("fn:concat")
let $description := "hello"
let $value := (1, "two", <three/>)
return
    error($code, $description, $value)