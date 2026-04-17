(: Parse Contextual Query Language (CQL/SRU v1.2) expressions :)
(: Output as XCQL (XML, default) or CQL (string) :)
let $query := 'dc.title = "eXist" and dc.creator = "Smith"'
return
  <results>
    <xcql-output>
      {cqlparser:parse-cql($query, "XCQL")}
    </xcql-output>
    <cql-output>
      {cqlparser:parse-cql($query, "CQL")}
    </cql-output>
    <simple-term>
      {cqlparser:parse-cql("XQuery", "XCQL")}
    </simple-term>
  </results>
