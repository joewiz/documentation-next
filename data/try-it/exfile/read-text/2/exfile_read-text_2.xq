import module namespace exfile = "http://expath.org/ns/file";

(: Read text with encoding :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "Héllo Wörld", "UTF-8")
let $text := exfile:read-text($f, "UTF-8")
let $_ := exfile:delete($f)
return $text
