(: Apply XSLT with parameters, factory attributes, and serialization options :)
let $source := <name>World</name>
let $stylesheet :=
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        <xsl:param name="greeting"/>
        <xsl:template match="name">
            <message><xsl:value-of select="$greeting"/>, <xsl:value-of select="."/>!</message>
        </xsl:template>
    </xsl:stylesheet>
let $params :=
    <parameters>
        <param name="greeting" value="Hello"/>
    </parameters>

return transform:transform($source, $stylesheet, $params, (), ())
