(: generate-id#0 uses the context item :)
let $nodes := (<a/>, <b/>, <c/>)
for $n in $nodes
return generate-id($n)