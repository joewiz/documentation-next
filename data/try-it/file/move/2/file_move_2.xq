(: Move (rename) a file or directory :)
let $tmp := util:system-property("java.io.tmpdir")
let $src := $tmp || "/exist-tryit-move-src"
let $dst := $tmp || "/exist-tryit-move-dst"
let $_ := file:mkdir($src)
let $moved := file:move($src, $dst)
let $_ := file:delete($dst)
return "Moved: " || $moved
