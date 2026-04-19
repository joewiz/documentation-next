(: Get function items from a module at a given location :)
try {
    let $fns := inspect:module-functions(xs:anyURI("/db/apps/docs/modules/fundocs.xqm"))
    return
        for $fn in $fns
        return function-name($fn) || "#" || function-arity($fn)
} catch * {
    "inspect:module-functions#1 — returns function items for a module at a source location. Error: " || $err:description
}
