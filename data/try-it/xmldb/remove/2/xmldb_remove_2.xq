let $_ := xmldb:store("/db/apps/docs/data/try-it", "remove-test.xml", <test/>)
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "remove-test.xml")
return "Stored and removed resource"