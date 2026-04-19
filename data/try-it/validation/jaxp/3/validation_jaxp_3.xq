(: Validate by parsing with JAXP using grammar caching and an XML catalog :)
let $doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
return validation:jaxp($doc, true(), ())
