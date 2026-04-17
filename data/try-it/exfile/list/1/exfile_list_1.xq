import module namespace exfile = "http://expath.org/ns/file";

(: List files in a directory :)
let $dir := exfile:create-temp-dir("tryit", ".d")
let $_ := exfile:write-text($dir || "/test.txt", "test")
let $_ := exfile:write-text($dir || "/data.xml", "<data/>")
let $files := exfile:list($dir)
let $_ := exfile:delete($dir, true())
return $files
