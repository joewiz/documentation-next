let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "copy-src")
let $_ := xmldb:store("/db/apps/docs/data/try-it/copy-src", "test.xml", <test/>)
let $_ := xmldb:copy-collection("/db/apps/docs/data/try-it/copy-src", "/db/apps/docs/data/try-it/copy-dst")
let $_ := (xmldb:remove("/db/apps/docs/data/try-it/copy-src"), xmldb:remove("/db/apps/docs/data/try-it/copy-dst"))
return "Copied collection"