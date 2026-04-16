try { util:declared-variables(xs:anyURI("http://exist-db.org/xquery/util")) }
catch * { "declared-variables: " || $err:description }