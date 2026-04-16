(: remove#1 deletes a collection — demo with create/remove :)
let $_ := xmldb:create-collection("/db/apps/docs/data/try-it", "remove-test")
let $_ := xmldb:remove("/db/apps/docs/data/try-it/remove-test")
return "Created and removed collection"