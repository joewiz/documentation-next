(: Execute a SQL statement :)
"sql:execute($connection-handle as xs:long, $sql-statement as xs:string, $make-node-from-column-name as xs:boolean) as element()? — executes SQL and returns XML results; column names become element names when the flag is true"
