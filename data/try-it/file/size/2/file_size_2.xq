import module namespace exfile = "http://expath.org/ns/file";

(: Get the size of a directory entry :)
let $tmp := exfile:temp-dir()
return "Temp dir path: " || $tmp
