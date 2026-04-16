let $qname := xs:QName("fn:concat")
let $comparison-value := "example"
let $element-or-attribute := true()
return
    util:qname-index-lookup($qname, $comparison-value, $element-or-attribute)