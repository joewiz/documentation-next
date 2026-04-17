import module namespace exfile = "http://expath.org/ns/file";

(: Create a temporary file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "Hello!")
let $content := exfile:read-text($f)
let $_ := exfile:delete($f)
return "Temp file content: " || $content
