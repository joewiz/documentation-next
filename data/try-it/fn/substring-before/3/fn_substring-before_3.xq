let $value := "Straße"
let $substring := "ße"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    substring-before($value, $substring, $collation)