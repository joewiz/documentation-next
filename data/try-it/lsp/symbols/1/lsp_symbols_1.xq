import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: List all declared symbols (functions and variables) in an expression :)
lsp:symbols(``[
    declare variable $greeting := "hello";
    declare function local:greet($name) {
        $greeting || ", " || $name || "!"
    };
    local:greet("world")
]``)
