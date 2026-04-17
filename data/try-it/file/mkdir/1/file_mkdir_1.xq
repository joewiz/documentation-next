(: Create a directory :)
let $dir := util:system-property("java.io.tmpdir") || "/exist-tryit-mkdir"
let $created := file:mkdir($dir)
let $_ := file:delete($dir)
return "Created: " || $created
