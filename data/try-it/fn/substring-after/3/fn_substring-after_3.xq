let $value := "Straße"
let $substring := "ra"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    substring-after($value, $substring, $collation)