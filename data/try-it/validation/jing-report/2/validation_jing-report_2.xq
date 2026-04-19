(: Get a detailed Jing validation report :)
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
let $invalid-doc :=
    <person>
        <name>Bob</name>
        <age>-5</age>
    </person>
return validation:jing-report($invalid-doc, $schema)
