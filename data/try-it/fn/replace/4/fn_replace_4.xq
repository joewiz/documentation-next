let $input := "Hello World"
let $pattern := "hello"
let $replacement := "Hi"
let $flags := "i"
return
    replace($input, $pattern, $replacement, $flags)