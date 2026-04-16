(: invisible-xml parses text using an ixml grammar :)
let $grammar := "date: year, '-', month, '-', day .
year: digit, digit, digit, digit .
month: digit, digit .
day: digit, digit .
digit: ['0'-'9'] ."
return
    invisible-xml($grammar)("2025-06-15")