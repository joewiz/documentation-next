let $_ := xmldb:store("/db/apps/docs/data/try-it", "touch-test.xml", <test/>)
let $_ := xmldb:touch("/db/apps/docs/data/try-it", "touch-test.xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "touch-test.xml")
return "Touched resource"