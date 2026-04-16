let $values := "foo"
let $collation := "hello"
return
    all-equal($values, $collation)