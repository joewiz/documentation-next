(: Get function items for all public functions in the current module :)
(: When called without arguments, inspects the calling module :)
let $fns := inspect:module-functions()
return
    if (exists($fns)) then
        for $fn in $fns
        return function-name($fn) || "#" || function-arity($fn)
    else
        "No functions found — this query has no module context"
