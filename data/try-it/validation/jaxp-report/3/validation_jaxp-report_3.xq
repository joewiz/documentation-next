(: JAXP validation report with grammar caching and optional catalog :)
let $doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
return validation:jaxp-report($doc, true(), ())
