import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Evaluate an expression and store results in a server-side cursor :)
let $result := lsp:eval("1 to 5")
return $result
