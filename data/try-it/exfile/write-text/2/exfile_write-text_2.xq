import module namespace exfile = "http://expath.org/ns/file";

(: Write text to a file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "Hello from XQuery!")
let $content := exfile:read-text($f)
let $_ := exfile:delete($f)
return $content
