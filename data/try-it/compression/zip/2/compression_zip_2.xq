(: Create a zip archive from entry elements :)
let $entries := (
    <entry name="greeting.txt" type="text">Hello from eXist-db!</entry>,
    <entry name="data.xml" type="xml"><root><item n="1"/></root></entry>
)
let $zip := compression:zip($entries, false())
return map {
    "zip-data": $zip,
    "description": "Zip archive with 2 entries (greeting.txt, data.xml)"
}
