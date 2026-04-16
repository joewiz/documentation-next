import module namespace exfile = "http://expath.org/ns/file";

(: Get the size of a file in bytes :)
let $tmp := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($tmp, "Hello World!")
let $sz := exfile:size($tmp)
let $_ := exfile:delete($tmp)
return "File size: " || $sz || " bytes"
