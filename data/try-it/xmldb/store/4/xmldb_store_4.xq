let $stored := xmldb:store("/db/apps/docs/data/try-it", "test.txt", "Hello World", "text/plain")
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "test.txt")
return "Stored and removed: " || $stored