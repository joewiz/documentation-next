(: Serialize an XML document to the filesystem :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-serialize.xml"
    let $doc := <greeting>Hello from eXist-db!</greeting>
    let $_ := file:serialize($doc, $path, ())
    let $exists := file:exists($path)
    let $_ := file:delete($path)
    return "Serialized to filesystem: " || $exists
} catch * { "file:serialize — " || $err:description }
