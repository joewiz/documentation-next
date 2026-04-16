import module namespace exfile = "http://expath.org/ns/file";

(: Get the last-modified timestamp of a file :)
let $tmp := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text($tmp, "test")
let $mod := exfile:last-modified($tmp)
let $_ := exfile:delete($tmp)
return "Last modified: " || $mod
