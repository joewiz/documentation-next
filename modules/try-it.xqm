xquery version "3.1";

(:~
 : Try-it query module.
 :
 : Loads pre-populated XQuery examples from data/try-it/{dir}/{name}/{arity}/.
 : The registry.xml maps directory names to module namespace URIs and prefixes,
 : allowing alignment even when runtime prefixes differ.
 :
 : Directory layout:
 :   data/try-it/registry.xml
 :   data/try-it/{dir}/{local-name}/{arity}/{dir}_{local-name}_{arity}.xq
 :
 : Example:
 :   data/try-it/fn/format-date/2/fn_format-date_2.xq
 :)
module namespace tryit = "http://exist-db.org/apps/docs/try-it";

import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

declare variable $tryit:root     := $config:data-root || "/try-it";
declare variable $tryit:registry := doc($tryit:root || "/registry.xml")/try-it-registry;

(: ========================= :)
(:  Public API               :)
(: ========================= :)

(:~
 : Find a try-it query for a function by prefix, local name, and arity.
 :
 : @param $prefix      the module namespace prefix (e.g. "fn")
 : @param $local-name  the function local name (e.g. "format-date")
 : @param $arity       the function arity
 : @return the XQuery source text, or empty sequence if not found
 :)
declare function tryit:find(
    $prefix as xs:string,
    $local-name as xs:string,
    $arity as xs:integer
) as xs:string? {
    let $dir := tryit:dir-for-prefix($prefix)
    where exists($dir)
    return
        let $filename := $dir || "_" || $local-name || "_" || $arity || ".xq"
        let $path := string-join(($tryit:root, $dir, $local-name, string($arity), $filename), "/")
        return
            if (util:binary-doc-available($path)) then
                let $text := unparsed-text($path)
                (: Trim leading/trailing whitespace but preserve internal formatting :)
                return replace(replace($text, "^\s+", ""), "\s+$", "")
            else ()
};

(:~
 : Check whether any try-it queries exist for a module prefix.
 :
 : @param $prefix  the module namespace prefix
 : @return true if the try-it directory for this prefix contains at least one .xq
 :)
declare function tryit:has-queries-for($prefix as xs:string) as xs:boolean {
    let $dir := tryit:dir-for-prefix($prefix)
    return
        if (exists($dir)) then
            xmldb:collection-available($tryit:root || "/" || $dir)
        else false()
};

(: ========================= :)
(:  Registry lookup          :)
(: ========================= :)

(:~
 : Resolve a module prefix to a try-it directory name via the registry.
 :
 : Looks up by @prefix first (most common), then falls back to using
 : the prefix directly as the directory name (convention-over-configuration).
 :
 : @param $prefix the module namespace prefix
 : @return the directory name, or the prefix itself as fallback
 :)
declare %private function tryit:dir-for-prefix(
    $prefix as xs:string
) as xs:string {
    let $entry := $tryit:registry/module[@prefix = $prefix]
    return ($entry/@dir/string(), $prefix)[1]
};

(:~
 : Resolve a module namespace URI to a try-it directory name.
 :
 : @param $uri the module namespace URI
 : @return the directory name, or empty sequence
 :)
declare function tryit:dir-for-uri($uri as xs:string) as xs:string? {
    $tryit:registry/module[@uri = $uri]/@dir/string()
};
