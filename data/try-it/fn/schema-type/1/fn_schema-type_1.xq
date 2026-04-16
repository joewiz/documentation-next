(: schema-type returns type info — use a known XSD type :)
try { schema-type(xs:QName("xs:integer")) }
catch * { "schema-type not supported: " || $err:description }