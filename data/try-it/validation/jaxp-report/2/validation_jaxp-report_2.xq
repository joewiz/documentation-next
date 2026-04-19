(: Get a detailed JAXP validation report :)
let $doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
return validation:jaxp-report($doc, false())
