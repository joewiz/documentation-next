let $input := "The quick brown fox"
let $pattern := "fox"
let $replacement := "cat"
return
    replace($input, $pattern, $replacement)