xquery version "3.1";

(:~
 : Application configuration module.
 :
 : Provides paths and optional dependency detection.
 :)
module namespace config = "http://exist-db.org/apps/docs/config";

declare namespace repo = "http://exist-db.org/xquery/repo";

(: Resolve app root from module load path.
 : system:get-module-load-path() returns the directory of this file,
 : which is modules/ — strip that suffix to get the package root. :)
declare variable $config:app-root :=
    let $rawPath := system:get-module-load-path()
    let $modulePath :=
        if (starts-with($rawPath, "xmldb:exist://embedded-eXist-server")) then
            substring($rawPath, 36)
        else if (starts-with($rawPath, "xmldb:exist://")) then
            substring($rawPath, 15)
        else
            $rawPath
    return
        substring-before($modulePath, "/modules");

declare variable $config:data-root := $config:app-root || "/data";
declare variable $config:functions-data := $config:data-root || "/functions";

declare variable $config:app-base :=
    request:get-context-path() || "/apps/docs";

(:~
 : Check whether exist-api is installed (for Try-it buttons).
 :)
declare function config:has-api() as xs:boolean {
    "http://exist-db.org/pkg/api" = repo:list()
};
