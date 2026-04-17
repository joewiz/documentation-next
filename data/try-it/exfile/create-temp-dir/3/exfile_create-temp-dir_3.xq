import module namespace exfile = "http://expath.org/ns/file";

(: Create temp directory in a specific parent :)
let $dir := exfile:create-temp-dir("tryit", ".d", exfile:temp-dir())
let $_ := exfile:delete($dir)
return "Created in: " || exfile:parent($dir)
