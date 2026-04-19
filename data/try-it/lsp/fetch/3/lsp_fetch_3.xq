import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Evaluate, then fetch a page of results from the cursor :)
let $result := lsp:eval("for $i in 1 to 20 return <item n='{$i}'/>")
let $page := lsp:fetch($result?cursor, 1, 5)
let $_ := lsp:close($result?cursor)
return map {
    "total": $result?items,
    "fetched": array:size($page),
    "page": $page
}
