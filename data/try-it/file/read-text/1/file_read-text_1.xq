import module namespace exfile = "http://expath.org/ns/file";

(: Read text from a file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "XQuery is powerful!")
let $text := exfile:read-text($f)
let $_ := exfile:delete($f)
return $text
