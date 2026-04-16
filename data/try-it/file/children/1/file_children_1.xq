import module namespace exfile = "http://expath.org/ns/file";

(: List children of a directory :)
let $dir := exfile:create-temp-dir("tryit", ".d")
let $_ := exfile:write-text($dir || "/a.txt", "a")
let $_ := exfile:write-text($dir || "/b.txt", "b")
let $children := exfile:children($dir)
let $_ := exfile:delete($dir, true())
return
    for $c in $children
    return exfile:name($c)
