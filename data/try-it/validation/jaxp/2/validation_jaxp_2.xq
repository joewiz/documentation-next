(: Validate by parsing with JAXP — uses grammars referenced in the document :)
let $doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
return validation:jaxp($doc, false())
