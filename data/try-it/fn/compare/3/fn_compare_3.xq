let $value-1 := "Straße"
let $value-2 := "Strasse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de"
return
    compare($value-1, $value-2, $collation)