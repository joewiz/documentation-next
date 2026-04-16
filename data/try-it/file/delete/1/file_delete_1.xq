import module namespace exfile = "http://expath.org/ns/file";

(: Delete a file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($f, "delete me")
let $existed := exfile:exists($f)
let $_ := exfile:delete($f)
return "Existed: " || $existed || ", Deleted: " || not(exfile:exists($f))
