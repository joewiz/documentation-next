import module namespace exfile = "http://expath.org/ns/file";

(: Check if a path is a file :)
let $tmp := exfile:temp-dir()
return
    $tmp || " is-exfile: " || exfile:is-file($tmp)
