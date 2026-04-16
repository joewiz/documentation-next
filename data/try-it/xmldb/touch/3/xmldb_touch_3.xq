let $_ := xmldb:store("/db/apps/docs/data/try-it", "touch3-test.xml", <test/>)
let $_ := xmldb:touch("/db/apps/docs/data/try-it", "touch3-test.xml", current-dateTime())
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "touch3-test.xml")
return "Touched with timestamp"