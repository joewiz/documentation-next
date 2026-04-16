let $xml :=
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="name">eXist-db</string>
        <number key="version">7</number>
    </map>
let $options := map { "indent": true() }
return
    xml-to-json($xml, $options)