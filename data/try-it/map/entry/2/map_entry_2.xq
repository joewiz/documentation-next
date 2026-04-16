let $key := "foo"
let $value := (1, "two", <three/>)
return
    map:entry($key, $value)