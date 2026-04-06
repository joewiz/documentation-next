xquery version "3.1";

(:~
 : Regenerate XQDoc data endpoint.
 :
 : Rescans all modules, regenerates stored XQDoc XML,
 : and reindexes the data collection.
 :
 : This script runs with setgid DBA permissions (set during pre-install),
 : so any authenticated user can trigger regeneration without being a DBA.
 :)

import module namespace fundocs = "http://exist-db.org/apps/docs/fundocs"
    at "fundocs.xqm";
import module namespace config = "http://exist-db.org/apps/docs/config"
    at "config.xqm";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

try {
    let $summary := fundocs:generate-all()
    let $_ := xmldb:reindex($config:functions-data)
    return map {
        "status": "ok",
        "total": xs:integer($summary/total),
        "generated": xs:integer($summary/generated)
    }
} catch * {
    response:set-status-code(500),
    map {
        "status": "error",
        "message": $err:description
    }
}
