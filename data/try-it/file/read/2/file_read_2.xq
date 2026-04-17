(: Read an XML file with serialization options :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-read2.xml"
    let $_ := file:serialize(doc("/db/apps/docs/data/try-it/ft/data/poems.xml"), $path, ())
    let $doc := file:read($path, "UTF-8")
    let $_ := file:delete($path)
    return "Read document with " || count($doc//*) || " elements"
} catch * { "file:read#2 — " || $err:description }
