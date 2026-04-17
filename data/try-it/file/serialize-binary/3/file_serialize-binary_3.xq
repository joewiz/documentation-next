(: Append binary data to an existing file :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-append.dat"
    let $_ := file:serialize-binary(util:string-to-binary("Hello"), $path)
    let $_ := file:serialize-binary(util:string-to-binary(" World"), $path, true())
    let $text := file:read-unicode($path)
    let $_ := file:delete($path)
    return $text
} catch * { "file:serialize-binary#3 — " || $err:description }
