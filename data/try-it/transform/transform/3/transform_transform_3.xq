(: Apply an inline XSLT stylesheet to an XML document :)
let $source :=
    <items>
        <item name="Apple" price="1.20"/>
        <item name="Banana" price="0.50"/>
        <item name="Cherry" price="3.00"/>
    </items>

let $stylesheet :=
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
        <xsl:template match="items">
            <ul>
                <xsl:for-each select="item">
                    <li><xsl:value-of select="@name"/>: $<xsl:value-of select="@price"/></li>
                </xsl:for-each>
            </ul>
        </xsl:template>
    </xsl:stylesheet>

return transform:transform($source, $stylesheet, ())
