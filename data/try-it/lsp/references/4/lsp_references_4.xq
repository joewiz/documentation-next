import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Find references with a module load path :)
let $expr := ``[
    declare function local:double($n) { $n * 2 };
    local:double(3),
    local:double(7)
]``
(: Line 1, column 27 points to local:double in its declaration :)
return lsp:references($expr, 1, 27, ())
