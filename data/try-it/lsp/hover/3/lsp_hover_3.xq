import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Get hover information for a function at a given position :)
(: Line 0, column 0 points to "count" in the expression below :)
lsp:hover("count((1, 2, 3))", 0, 0)
