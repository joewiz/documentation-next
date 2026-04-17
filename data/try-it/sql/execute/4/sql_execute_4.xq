(: Execute a prepared statement with parameters :)
"sql:execute($connection-handle as xs:long, $statement-handle as xs:long, $parameters as element()?, $make-node-from-column-name as xs:boolean) as element()? — executes a prepared statement; params: <sql:parameters><sql:param sql:type='varchar'>value</sql:param></sql:parameters>"
