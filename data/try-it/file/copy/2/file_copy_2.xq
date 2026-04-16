import module namespace exfile = "http://expath.org/ns/file";

(: Copy a file :)
let $src := exfile:create-temp-file("tryit-src", ".txt")
let $dst := exfile:temp-dir() || "tryit-dst-" || generate-id(<x/>) || ".txt"
let $_ := exfile:write-text($src, "Original content")
let $_ := exfile:copy($src, $dst)
let $content := exfile:read-text($dst)
let $_ := (exfile:delete($src), exfile:delete($dst))
return "Copied: " || $content
