(: Parse a document in validating mode — defaults are filled in from the grammar :)
let $doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
return validation:jaxp-parse($doc, false(), ())
