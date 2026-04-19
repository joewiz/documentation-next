import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Find the definition of a user-declared variable :)
let $expr := ``[
    let $greeting := "hello"
    return $greeting
]``
(: Line 2, column 11 points to $greeting in the return clause :)
return lsp:definition($expr, 2, 11)
