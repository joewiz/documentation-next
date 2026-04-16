let $value-1 := "foo"
let $value-2 := "foo"
let $collation-uri := "hello"
return
    compare($value-1, $value-2, $collation-uri)