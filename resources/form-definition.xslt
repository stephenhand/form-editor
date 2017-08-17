<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/fm">
        <DIV>
            <xsl:apply-templates/>
        </DIV>
    </xsl:template>
    <xsl:template match="field">
        <INPUT TYPE="text"/>
    </xsl:template>
    <xsl:template match="label">
        <SPAN><xsl:value-of select="@text"/></SPAN>
    </xsl:template>
</xsl:stylesheet>