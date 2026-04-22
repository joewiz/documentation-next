xquery version "3.1";

(:~
 : Function documentation REST API.
 :
 : Serves function documentation from the pre-indexed XQDoc data
 : for use by hover popups, IDEs, and external tools.
 :)
module namespace fn-api = "http://exist-db.org/apps/docs/fn-api";

import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "fundocs.xqm";
import module namespace errors = "http://e-editiones.org/roaster/errors";

(:~
 : GET /api/functions/{prefix}/{name}
 :
 : Returns function documentation as JSON. If multiple modules share the
 : same prefix, all matching functions are returned with their module URI
 : for disambiguation.
 :
 : Response format:
 : {
 :   "name": "crypto:hash",
 :   "prefix": "crypto",
 :   "local-name": "hash",
 :   "signatures": [
 :     {
 :       "signature": "crypto:hash($data as item(), $algorithm as xs:string) as xs:string",
 :       "description": "...",
 :       "arity": 2,
 :       "module-uri": "http://expath.org/ns/crypto",
 :       "parameters": [...]
 :     }
 :   ],
 :   "url": "/exist/apps/docs/functions/crypto/hash"
 : }
 :)
declare function fn-api:get-function($request as map(*)) {
    let $prefix := $request?parameters?prefix
    let $name := $request?parameters?name
    let $functions := fundocs:get-function($prefix, $name)
    return
        if (empty($functions)) then
            error($errors:NOT_FOUND, "Function not found: " || $prefix || ":" || $name)
        else
            let $ctx := request:get-context-path()
            return map {
                "name": $prefix || ":" || $name,
                "prefix": $prefix,
                "local-name": $name,
                "url": $ctx || "/apps/docs/functions/" || $prefix || "/" || $name,
                "signatures": array {
                    for $fn in $functions
                    return map {
                        "signature": $fn?signature,
                        "description": $fn?description,
                        "arity": $fn?arity,
                        "module-uri": (
                            (: Look up module URI from the XQDoc data :)
                            let $modules := fundocs:get-module($prefix)
                            for $m in $modules
                            return $m?uri
                        )[1],
                        "parameters": $fn?parameters,
                        "return": $fn?return,
                        "deprecated": $fn?is-deprecated
                    }
                }
            }
};

(:~
 : POST /api/xqdoc/regenerate
 :)
declare function fn-api:regenerate-xqdoc($request as map(*)) {
    fundocs:generate-all()
};
