import module namespace exfile = "http://expath.org/ns/file";

(: Write multiple lines to a file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text-lines($f, ("apple", "banana", "cherry"))
let $content := exfile:read-text($f)
let $_ := exfile:delete($f)
return $content
