import module namespace exfile = "http://expath.org/ns/file";

(: Read lines from a text file :)
let $f := exfile:create-temp-file("tryit", ".txt")
let $_ := exfile:write-text-lines($f, ("Line 1", "Line 2", "Line 3"))
let $lines := exfile:read-text-lines($f)
let $_ := exfile:delete($f)
return
    for $line at $n in $lines
    return $n || ": " || $line
