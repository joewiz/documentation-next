let $source := "Straße"
let $substring := "strasse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de;strength=secondary"
return
    contains($source, $substring, $collation)