import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Find a definition with a module load path for cross-module lookups :)
let $expr := ``[
    import module namespace sm = "http://exist-db.org/xquery/securitymanager";
    sm:id()
]``
return lsp:definition($expr, 2, 4, "xmldb:exist:///db")
