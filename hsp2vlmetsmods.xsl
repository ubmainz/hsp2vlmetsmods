<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:template match="/">
        <mets:mets>
            <mets:metsHdr>
                <mets:agent ROLE="CREATOR">
                    <mets:name>hsp2vlmetsmods-Skript Knepper 02/2024</mets:name>
                </mets:agent>
            </mets:metsHdr>
            <xsl:message>
                <xsl:text>Processing </xsl:text>
                <xsl:value-of select="base-uri()"/>
            </xsl:message>
            <xsl:for-each select="//TEI:fileDesc">
                <mets:dmdSec ID="{TEI:sourceDesc/TEI:msDesc/@xml:id}">
                    <mets:mdWrap MIMETYPE="text/xml" MDTYPE="MODS">
                        <mets:xmlData>
                            <mods:mods>
                                <mods:recordInfo>
                                    <mods:recordIdentifier>
                                        <xsl:value-of select="TEI:sourceDesc/TEI:msDesc/@xml:id"/>
                                    </mods:recordIdentifier>
                                </mods:recordInfo>
                                <xsl:apply-templates mode="mods"/>
                            </mods:mods>
                        </mets:xmlData>
                    </mets:mdWrap>
                </mets:dmdSec>
            </xsl:for-each>
            <mets:structMap TYPE="logical">
                <xsl:apply-templates mode="map"/>
            </mets:structMap>
        </mets:mets>
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName='norm_title']" mode="mods">
        <mods:titleInfo>
            <mods:title>
                <xsl:value-of select="TEI:term[@type='title']"/>
            </mods:title>
        </mods:titleInfo> 
    </xsl:template>
    
    <xsl:template match="text()" mode="#all"/>
    
</xsl:stylesheet>