(: Get function items for a module identified by namespace URI :)
let $fns := inspect:module-functions-by-uri(
    xs:anyURI("http://www.w3.org/2005/xpath-functions/math")
)
return
    for $fn in $fns
    order by function-name($fn), function-arity($fn)
    return function-name($fn) || "#" || function-arity($fn)
