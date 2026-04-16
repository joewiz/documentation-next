let $input := "Hello World"
let $pattern := "hello"
let $flags := "i"
return
    matches($input, $pattern, $flags)