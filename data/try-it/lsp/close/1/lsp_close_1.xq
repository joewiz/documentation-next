import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Create a cursor, then close it to release server-side resources :)
let $result := lsp:eval("1 to 100")
let $closed := lsp:close($result?cursor)
let $closed-again := lsp:close($result?cursor)
return map {
    "first-close": $closed,
    "second-close-already-gone": $closed-again
}
