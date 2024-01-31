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
            <xsl:apply-templates mode="mods"/>
            <mets:structMap TYPE="logical">
                <xsl:apply-templates mode="map"/>
            </mets:structMap>
        </mets:mets>
    </xsl:template>
 
    <xsl:template match="TEI:sourceDesc" mode="mods">
        <mets:dmdSec ID="{TEI:msDesc/@xml:id}">
            <mets:mdWrap MIMETYPE="text/xml" MDTYPE="MODS">
                <mets:xmlData>
                    <mods:mods>
                        <mods:recordInfo>
                            <mods:recordIdentifier>
                                <xsl:value-of select="TEI:msDesc/@xml:id"/>
                            </mods:recordIdentifier>
                        </mods:recordInfo>
                        <mods:originInfo>
                            <xsl:apply-templates mode="mods-origininfo"/>
                        </mods:originInfo>
                        <xsl:apply-templates mode="mods"/>
                    </mods:mods>
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec> 
    </xsl:template>
 
    <xsl:template match="TEI:index[@indexName='norm_title']" mode="mods">
        <mods:titleInfo>
            <mods:title>
                <xsl:value-of select="TEI:term[@type='title']"/>
            </mods:title>
        </mods:titleInfo> 
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName='norm_origDate']" mode="mods-origininfo">
        <mods:dateIssued>
            <xsl:value-of select="TEI:term[@type='origDate']"/>
        </mods:dateIssued>
        <dateIssued encoding="w3cdtf" point="start" keyDate="yes">
            <xsl:value-of select="TEI:term[@type='origDate_notBefore']"/>
        </dateIssued>
        <dateIssued encoding="w3cdtf" point="end">
            <xsl:value-of select="TEI:term[@type='origDate_notAfter']"/>
        </dateIssued>
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName='norm_origPlace']" mode="mods-origininfo">
        <mods:place>
            <xsl:for-each select="TEI:term[@type='origPlace']">
                <mods:placeTerm type="text">
                    <xsl:value-of select="."/>
                </mods:placeTerm>
            </xsl:for-each>
            <xsl:for-each select="TEI:term[@type='origPlace_norm'][starts-with(@ref,'http://d-nb.info/gnd/')]">
                <mods:placeTerm authority="gnd" authorityURI="http://d-nb.info/gnd/" valueURI="{@ref}">
                    <xsl:value-of select="TEI:term[@type='origPlace_norm']"/>
                </mods:placeTerm>
            </xsl:for-each>
        </mods:place>

    </xsl:template>
    
    <xsl:template match="TEI:sourceDesc" mode="map">
        <xsl:message>
            <xsl:text>Found: </xsl:text>
            <xsl:value-of select="TEI:msDesc/@xml:id"/>
        </xsl:message>
        <mets:div TYPE="document" DMDID="{concat('md-',TEI:msDesc/@xml:id)}" LABEL="Handschrift"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="#all"/>
    
</xsl:stylesheet>