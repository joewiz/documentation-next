import module namespace exfile = "http://expath.org/ns/file";

(: Create a temporary directory :)
let $dir := exfile:create-temp-dir("tryit", ".d")
let $exists := exfile:is-dir($dir)
let $_ := exfile:delete($dir)
return "Temp dir: " || $dir || " (existed: " || $exists || ")"
