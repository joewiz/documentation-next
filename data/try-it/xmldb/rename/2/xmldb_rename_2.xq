let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "rename-src")
let $_ := xmldb:rename("/db/apps/docs/data/try-it/rename-src", "rename-dst")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/rename-dst")
return "Renamed collection"