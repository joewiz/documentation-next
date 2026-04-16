import module namespace exfile = "http://expath.org/ns/file";

(: Append text to an existing file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "Hello")
let $_ := exfile:append-text($f, " World!")
let $content := exfile:read-text($f)
let $_ := exfile:delete($f)
return $content
