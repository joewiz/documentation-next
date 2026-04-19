import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Get completions with a module load path for resolving imports :)
let $items := lsp:completions(
    ``[
        import module namespace sm = "http://exist-db.org/xquery/securitymanager";
        sm:
    ]``,
    "xmldb:exist:///db"
)
return map {
    "count": array:size($items),
    "first-5": array:subarray($items, 1, min((5, array:size($items))))
}
