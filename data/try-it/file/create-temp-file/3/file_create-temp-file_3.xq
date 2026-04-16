import module namespace exfile = "http://expath.org/ns/file";

(: Create temp file in a specific directory :)
let $f := exfile:create-temp-file("tryit", ".txt", exfile:temp-dir())
let $_ := exfile:delete($f)
return "Created: " || exfile:name($f)
