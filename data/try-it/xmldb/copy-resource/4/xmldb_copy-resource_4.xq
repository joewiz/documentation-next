let $_ := xmldb:store("/db/apps/docs/data/try-it", "copy-src.xml", <test/>)
let $_ := xmldb:copy-resource("/db/apps/docs/data/try-it", "copy-src.xml", "/db/apps/docs/data/try-it", "copy-dst.xml")
let $_ := (xmldb:remove("/db/apps/docs/data/try-it", "copy-src.xml"), xmldb:remove("/db/apps/docs/data/try-it", "copy-dst.xml"))
return "Copied resource"