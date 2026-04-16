let $xml :=
    <map xmlns="http://www.w3.org/2005/xpath-functions">
        <string key="name">eXist-db</string>
        <boolean key="active">true</boolean>
        <number key="major-version">7</number>
        <array key="platforms">
            <string>Linux</string>
            <string>macOS</string>
            <string>Windows</string>
        </array>
    </map>
return fn:xml-to-json($xml, map { "indent": true() })
