import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Find all references to a variable in an expression :)
let $expr := ``[
    let $x := 1
    let $y := $x + 1
    return $x + $y
]``
(: Line 1, column 8 points to $x in its declaration :)
return lsp:references($expr, 1, 8)
