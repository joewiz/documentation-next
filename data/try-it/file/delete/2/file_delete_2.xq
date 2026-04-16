import module namespace exfile = "http://expath.org/ns/file";

(: Delete a directory recursively :)
let $dir := exfile:create-temp-dir("tryit", ".d")
let $_ := exfile:write-text($dir || "/file.txt", "test")
let $_ := exfile:create-dir($dir || "/subdir")
let $_ := exfile:delete($dir, true())
return "Deleted: " || not(exfile:exists($dir))
