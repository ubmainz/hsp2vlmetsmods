<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0" xmlns:ubmz="http://www.ub.uni-mainz.de"
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs ubmz TEI" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="/">
        <root>
            <xsl:apply-templates/>
        </root>
    </xsl:template>

    <xsl:template match="i">
        <xsl:message>
            <xsl:text>hsp-record: </xsl:text>
            <xsl:value-of select="."/>
        </xsl:message>
        <xsl:try>
            <record>
                <xsl:variable name="hsp-dok">
                    <xsl:copy-of select="document(ubmz:hspurl(.))"/>
                </xsl:variable>
                <xsl:copy-of select="$hsp-dok"/>
                <xsl:for-each select="$hsp-dok//TEI:listBibl/TEI:bibl/TEI:ref/@target">
                    <xsl:message>
                        <xsl:text>^--- hsp-description: </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:message>
                    <description-record>
                        <xsl:copy-of select="document(ubmz:hspurl(.))"/>
                    </description-record>
                </xsl:for-each>
            </record>
            <xsl:catch>
                <xsl:message>
                    <xsl:value-of select="$err:description"/>
                </xsl:message>
            </xsl:catch>
        </xsl:try>
    </xsl:template>

    <xsl:function name="ubmz:hspurl">
        <xsl:param name="id" as="xs:string"/>
        <xsl:sequence select="concat('https://handschriftenportal.de/api/tei/', $id)"/>
    </xsl:function>

</xsl:stylesheet>
