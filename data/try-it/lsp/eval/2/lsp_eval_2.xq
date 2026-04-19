import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Evaluate an expression with a module load path for resolving imports :)
let $result := lsp:eval(
    "collection('/db/apps/docs/data')//article/@title/string()",
    "xmldb:exist:///db"
)
return $result
