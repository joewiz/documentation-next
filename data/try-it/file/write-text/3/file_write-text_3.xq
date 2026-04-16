import module namespace exfile = "http://expath.org/ns/file";

(: Write text with specific encoding :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "Héllo", "ISO-8859-1")
let $content := exfile:read-text($f, "ISO-8859-1")
let $_ := exfile:delete($f)
return $content
