import module namespace exfile = "http://expath.org/ns/file";

(: Create a directory (including parents) :)
let $dir := exfile:temp-dir() || "tryit-test-" || generate-id(<x/>)
let $_ := exfile:create-dir($dir)
let $exists := exfile:is-dir($dir)
let $_ := exfile:delete($dir)
return "Created and verified: " || $exists
