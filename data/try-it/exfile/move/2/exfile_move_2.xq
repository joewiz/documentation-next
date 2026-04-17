import module namespace exfile = "http://expath.org/ns/file";

(: Move (rename) a file :)
let $src := exfile:create-temp-file("tryit-mv", ".txt")
let $dst := exfile:temp-dir() || "tryit-moved-" || generate-id(<x/>) || ".txt"
let $_ := exfile:write-text($src, "Moved content")
let $_ := exfile:move($src, $dst)
let $content := exfile:read-text($dst)
let $src-exists := exfile:exists($src)
let $_ := exfile:delete($dst)
return "Content: " || $content || ", source gone: " || not($src-exists)
