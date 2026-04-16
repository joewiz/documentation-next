let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "copy-src2")
let $_ := xmldb:copy-collection("/db/apps/docs/data/try-it/copy-src2", "/db/apps/docs/data/try-it", "copy-dst2")
let $_ := (xmldb:remove("/db/apps/docs/data/try-it/copy-src2"), xmldb:remove("/db/apps/docs/data/try-it/copy-dst2"))
return "Copied collection with new name"