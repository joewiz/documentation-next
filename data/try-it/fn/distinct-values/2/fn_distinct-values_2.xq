let $values := "foo"
let $collation := "hello"
return
    distinct-values($values, $collation)