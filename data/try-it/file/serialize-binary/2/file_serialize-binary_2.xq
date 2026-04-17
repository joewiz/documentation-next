(: Write binary data to the filesystem :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-binout.dat"
    let $data := util:string-to-binary("Binary content!")
    let $_ := file:serialize-binary($data, $path)
    let $exists := file:exists($path)
    let $_ := file:delete($path)
    return "Wrote binary: " || $exists
} catch * { "file:serialize-binary — " || $err:description }
