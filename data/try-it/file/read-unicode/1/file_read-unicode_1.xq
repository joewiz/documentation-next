(: Read a text file as a string :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-unicode.txt"
    let $_ := file:serialize-binary(util:string-to-binary("Hello Unicode! — äöü"), $path)
    let $text := file:read-unicode($path)
    let $_ := file:delete($path)
    return $text
} catch * { "file:read-unicode — " || $err:description }
