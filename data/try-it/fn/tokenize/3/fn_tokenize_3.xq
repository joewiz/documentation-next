let $value := "one:two::three"
let $pattern := ":"
let $flags := ""
return
    tokenize($value, $pattern, $flags)