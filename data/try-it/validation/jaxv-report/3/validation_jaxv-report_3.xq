(: Get a validation report with explicit schema language :)
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
let $doc :=
    <person>
        <name>Alice</name>
        <age>30</age>
    </person>
return validation:jaxv-report($doc, $schema, "http://www.w3.org/2001/XMLSchema")
