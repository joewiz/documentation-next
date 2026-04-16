(: Dynamically import a module :)
try {
    util:import-module(xs:anyURI("http://exist-db.org/xquery/util"), "u", xs:anyURI("http://exist-db.org/xquery/util")),
    "Module imported"
} catch * { "import-module: " || $err:description }