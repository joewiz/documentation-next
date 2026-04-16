let $_ := xmldb:store("/db/apps/docs/data/try-it", "copy-src2.xml", <test/>)
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "copy-target")
let $_ := xmldb:copy-resource("/db/apps/docs/data/try-it", "copy-src2.xml", "/db/apps/docs/data/try-it/copy-target", "copy-dst2.xml", true())
let $_ := (xmldb:remove("/db/apps/docs/data/try-it", "copy-src2.xml"), xmldb:remove("/db/apps/docs/data/try-it/copy-target"))
return "Copied resource (preserve)"