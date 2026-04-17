(: Read an XML file from the filesystem as a document :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-read.xml"
    let $_ := file:serialize(doc("/db/apps/docs/data/try-it/ft/data/poems.xml"), $path, ())
    let $doc := file:read($path)
    let $_ := file:delete($path)
    return "Read " || count($doc//poem) || " poems from filesystem"
} catch * { "file:read — " || $err:description }
