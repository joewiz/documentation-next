(: Inspect a library module from its source location in the database :)
(: Returns module description with all functions and variables :)
try {
    inspect:inspect-module(xs:anyURI("/db/apps/docs/modules/fundocs.xqm"))
} catch * {
    "inspect:inspect-module#1 — compiles a module from source and returns its XML description. Error: " || $err:description
}
