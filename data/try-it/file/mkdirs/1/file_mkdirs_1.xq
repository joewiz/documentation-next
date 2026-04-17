(: Create a directory including parent directories :)
let $dir := util:system-property("java.io.tmpdir") || "/exist-tryit/nested/dir"
let $created := file:mkdirs($dir)
let $_ := file:delete(util:system-property("java.io.tmpdir") || "/exist-tryit")
return "Created nested dirs: " || $created
