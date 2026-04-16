import module namespace exfile = "http://expath.org/ns/file";

(: List files matching a pattern :)
let $dir := exfile:create-temp-dir("tryit", ".d")
let $_ := (exfile:write-text($dir || "/a.txt", "a"),
           exfile:write-text($dir || "/b.xml", "b"),
           exfile:write-text($dir || "/c.txt", "c"))
let $txt-files := exfile:list($dir, false(), "*.txt")
let $_ := exfile:delete($dir, true())
return $txt-files
