let $qname := xs:QName("fn:concat")
let $comparison-value := "example"
return
    util:qname-index-lookup($qname, $comparison-value)