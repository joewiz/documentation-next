let $source := "Straße"
let $suffix := "sse"
let $collation := "http://www.w3.org/2013/collation/UCA?lang=de;strength=secondary"
return
    ends-with($source, $suffix, $collation)