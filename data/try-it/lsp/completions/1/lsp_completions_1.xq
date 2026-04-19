import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Get code completions available in the context of an expression :)
let $items := lsp:completions("let $x := fn:con")
return map {
    "count": array:size($items),
    "first-5": array:subarray($items, 1, min((5, array:size($items))))
}
