let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "move-src")
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "move-dst")
let $_ := xmldb:move("/db/apps/docs/data/try-it/move-src", "/db/apps/docs/data/try-it/move-dst")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/move-dst")
return "Moved collection"