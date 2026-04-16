let $expression := "hello"
let $default-serialization-params := "hello"
let $starting-loc := "example"
let $length := "example"
return
    util:eval-and-serialize($expression, $default-serialization-params, $starting-loc, $length)