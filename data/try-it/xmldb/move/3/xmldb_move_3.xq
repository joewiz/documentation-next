let $_ := xmldb:store("/db/apps/docs/data/try-it", "move-test.xml", <test/>)
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "move-target")
let $_ := xmldb:move("/db/apps/docs/data/try-it", "/db/apps/docs/data/try-it/move-target", "move-test.xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/move-target")
return "Moved resource"