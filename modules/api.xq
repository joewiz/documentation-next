xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:media-type "application/json";

import module namespace roaster = "http://e-editiones.org/roaster";
import module namespace fn-api = "http://exist-db.org/apps/docs/fn-api"
    at "fn-api.xqm";

roaster:route("modules/api.json",
    function($name as xs:string) {
        function-lookup(xs:QName($name), 1)
    }
)
