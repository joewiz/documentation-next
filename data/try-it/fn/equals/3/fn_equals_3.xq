let $source := "Straße"
let $target := "strasse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de;strength=secondary"
return
    equals($source, $target, $collation)