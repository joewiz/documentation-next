(: Create a tar archive from entry elements :)
try {
    let $entries := (
        <entry name="readme.txt" type="text">Tar archive example</entry>,
        <entry name="data.xml" type="xml"><items><item n="1"/></items></entry>
    )
    return compression:tar($entries, false())
} catch * {
    "compression:tar#2 — creates a tar archive from entries and/or collection URIs. Error: " || $err:description
}
