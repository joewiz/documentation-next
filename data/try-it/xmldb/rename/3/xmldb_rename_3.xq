let $_ := xmldb:store("/db/apps/docs/data/try-it", "rename-test.xml", <test/>)
let $_ := xmldb:rename("/db/apps/docs/data/try-it", "rename-test.xml", "renamed.xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "renamed.xml")
return "Renamed resource"