(: Execute SQL with custom result namespace :)
"sql:execute($connection-handle as xs:long, $sql-statement as xs:string, $make-node-from-column-name as xs:boolean, $ns-uri as xs:string, $ns-prefix as xs:string) as element()? — like #3 but wraps result elements in the specified namespace"
