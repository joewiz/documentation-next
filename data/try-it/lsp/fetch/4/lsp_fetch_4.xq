import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Fetch results with custom serialization parameters :)
let $result := lsp:eval("<root><child>text</child></root>")
let $page := lsp:fetch($result?cursor, 1, 1, map {
    "method": "xml",
    "indent": "yes",
    "omit-xml-declaration": "yes"
})
let $_ := lsp:close($result?cursor)
return $page
