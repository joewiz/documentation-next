(: fn:transform applies an XSLT stylesheet :)
let $options := map {
    "stylesheet-text": '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">
        <xsl:template match="/"><out><xsl:value-of select="greeting"/></out></xsl:template>
    </xsl:stylesheet>',
    "source-node": <greeting>Hello from XSLT!</greeting>
}
return
    transform($options)?output