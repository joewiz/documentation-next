(: Read a text file with specific encoding :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-unicode2.txt"
    let $_ := file:serialize-binary(util:string-to-binary("Hello UTF-8!"), $path)
    let $text := file:read-unicode($path, "UTF-8")
    let $_ := file:delete($path)
    return $text
} catch * { "file:read-unicode#2 — " || $err:description }
