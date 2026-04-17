import module namespace exfile = "http://expath.org/ns/file";

(: Append lines to an existing file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text-lines($f, ("first", "second"))
let $_ := exfile:append-text-lines($f, ("third", "fourth"))
let $lines := exfile:read-text-lines($f)
let $_ := exfile:delete($f)
return $lines
