(: Read a binary file from the filesystem :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-bin.dat"
    let $data := util:string-to-binary("Hello from filesystem!")
    let $_ := file:serialize-binary($data, $path)
    let $read := file:read-binary($path)
    let $_ := file:delete($path)
    return "Read binary: " || util:binary-to-string($read)
} catch * { "file:read-binary — " || $err:description }
