let $data := util:string-to-binary("Hello Binary")
let $stored := xmldb:store-as-binary("/db/apps/docs/data/try-it", "test.bin", $data)
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "test.bin")
return "Stored: " || $stored