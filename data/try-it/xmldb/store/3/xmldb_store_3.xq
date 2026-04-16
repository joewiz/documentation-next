let $data := <test created="{current-dateTime()}">Hello from try-it!</test>
let $stored := xmldb:store("/db/apps/docs/data/try-it", "test-store.xml", $data)
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "test-store.xml")
return "Stored and removed: " || $stored