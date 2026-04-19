import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: Compile-check with a module load path so imports can resolve :)
lsp:diagnostics(
    ``[
        import module namespace sm = "http://exist-db.org/xquery/securitymanager";
        sm:id()
    ]``,
    "xmldb:exist:///db"
)
