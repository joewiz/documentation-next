xquery version "3.1";

(:~
 : XQSuite test runner.
 :
 : Invokes all test modules and outputs results as JSON.
 : Access via: /exist/rest/db/apps/docs/test/xqs/test-runner.xq
 :)

import module namespace test = "http://exist-db.org/xquery/xqsuite"
    at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "json";
declare option output:media-type "application/json";

test:suite((
    inspect:module-functions(xs:anyURI("test-suite.xql")),
    inspect:module-functions(xs:anyURI("diagnostics-suite.xql"))
))
