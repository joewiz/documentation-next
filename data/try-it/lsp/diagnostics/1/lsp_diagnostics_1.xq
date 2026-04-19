import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Compile-check XQuery expressions and return diagnostics :)
let $good := lsp:diagnostics("1 + 1")
let $bad := lsp:diagnostics("let $x := ")
return map {
    "valid-expression": $good,
    "invalid-expression": $bad
}
