xquery version "3.1";

module namespace config="http://e-editiones.org/tei-publisher/odd-global";

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
        substring-before($modulePath, "/modules")
;

declare variable $config:data-root := $config:app-root || "/data";

declare variable $config:register-root := $config:data-root || "/registers";

declare variable $config:data-default as xs:string := $config:data-root || "/";

declare variable $config:address-by-id as xs:boolean := false();
