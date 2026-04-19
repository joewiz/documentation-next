(: Validate an XML document against an XSD schema using JAXV :)
let $schema :=
    <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="person">
            <xs:complexType>
                <xs:sequence>
                    <xs:element name="name" type="xs:string"/>
                    <xs:element name="age" type="xs:positiveInteger"/>
                </xs:sequence>
            </xs:complexType>
        </xs:element>
    </xs:schema>
let $valid-doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
let $invalid-doc :=
    <person>
        <name>Bob</name>
        <age>-5</age>
    </person>
return map {
    "valid": validation:jaxv($valid-doc, $schema),
    "invalid": validation:jaxv($invalid-doc, $schema)
}
