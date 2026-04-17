(: Serialize with serialization parameters :)
try {
    let $path := util:system-property("java.io.tmpdir") || "/exist-tryit-serialize4.xml"
    let $doc := <data><item>test</item></data>
    let $params := <output:serialization-parameters xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
        <output:indent value="yes"/>
        <output:omit-xml-declaration value="yes"/>
    </output:serialization-parameters>
    let $_ := file:serialize($doc, $path, $params)
    let $text := file:read-unicode($path)
    let $_ := file:delete($path)
    return $text
} catch * { "file:serialize#4 — " || $err:description }
