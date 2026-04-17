import module namespace exfile = "http://expath.org/ns/file";

(: List all descendant files recursively :)
let $dir := exfile:create-temp-dir("tryit", ".d")
let $_ := (exfile:write-text($dir || "/a.txt", "a"),
           exfile:create-dir($dir || "/sub"),
           exfile:write-text($dir || "/sub/b.txt", "b"))
let $all := exfile:descendants($dir)
let $_ := exfile:delete($dir, true())
return
    for $f in $all return exfile:name($f)
