let $_ := xmldb:store("/db/apps/docs/data/try-it", "mime-test.xml", <test/>)
let $_ := xmldb:set-mime-type(xs:anyURI("/db/apps/docs/data/try-it/mime-test.xml"), "application/xml")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "mime-test.xml")
return "Set MIME type"