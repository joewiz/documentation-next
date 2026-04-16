let $coll := xmldb:create-collection("/db/apps/docs/data/try-it", "create-test")
let $_ := xmldb:remove($coll)
return "Created: " || $coll