let $_ := xmldb:store("/db/apps/docs/data/try-it", "update-test.xml", <root><item>old</item></root>)
let $doc := doc("/db/apps/docs/data/try-it/update-test.xml")
let $_ := xmldb:update($doc//item, <item>new</item>)
let $result := doc("/db/apps/docs/data/try-it/update-test.xml")//item/string()
let $_ := xmldb:remove("/db/apps/docs/data/try-it", "update-test.xml")
return "Updated: " || $result