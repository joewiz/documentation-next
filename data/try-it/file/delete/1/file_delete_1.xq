(: Delete a file or directory :)
let $dir := util:system-property("java.io.tmpdir") || "/exist-tryit-delete"
let $_ := file:mkdir($dir)
let $deleted := file:delete($dir)
return "Deleted: " || $deleted
