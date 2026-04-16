let $source := "Straße"
let $prefix := "str"
let $collation := "http://www.w3.org/2013/collation/UCA?strength=secondary"
return
    starts-with($source, $prefix, $collation)