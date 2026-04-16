let $input := "The year 2025 was great, and 2026 is better"
let $pattern := "\d{4}"
let $flags := "i"
return
    analyze-string($input, $pattern, $flags)