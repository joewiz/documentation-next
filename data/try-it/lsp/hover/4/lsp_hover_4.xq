import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Get hover info with a module load path for cross-module lookups :)
lsp:hover(
    ``[
        import module namespace sm = "http://exist-db.org/xquery/securitymanager";
        sm:id()
    ]``,
    2,
    8,
    "xmldb:exist:///db"
)
