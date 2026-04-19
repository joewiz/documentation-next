import module namespace lsp = "http://exist-db.org/xquery/lsp";

(: List symbols with a module load path for resolving imports :)
lsp:symbols(
    ``[
        import module namespace sm = "http://exist-db.org/xquery/securitymanager";
        declare function local:current-user() {
            sm:id()//sm:real/sm:username/string()
        };
        local:current-user()
    ]``,
    "xmldb:exist:///db"
)
