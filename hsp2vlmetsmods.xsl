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
 
    <xsl:template match="TEI:msDesc" mode="mods">
        <xsl:message>
            <xsl:text>MODS: </xsl:text>
            <xsl:value-of select="@xml:id"/>
        </xsl:message>
        <mets:dmdSec ID="{@xml:id}">
            <mets:mdWrap MIMETYPE="text/xml" MDTYPE="MODS">
                <mets:xmlData>
                    <mods:mods>
                        <mods:recordInfo>
                            <mods:recordIdentifier>
                                <xsl:value-of select="@xml:id"/>
                            </mods:recordIdentifier>
                        </mods:recordInfo>
                        <xsl:choose>
                            <xsl:when test="@type='hsp:object'">
                                <mods:identifier type="HSP">
                                    <xsl:value-of select="@xml:id"/>
                                </mods:identifier>
                            </xsl:when>
                            <xsl:when test="@type='hsp:description'">
                                <mods:location>
                                    <mods:url displayLabel="Ausführliche Beschreibung">
                                        <xsl:value-of select="concat('https://handschriftenportal.de/search?hspobjectid=',@xml:id)"/>
                                    </mods:url>
                                </mods:location>
                            </xsl:when>
                        </xsl:choose>
                        <mods:genre authority="marcgt">script</mods:genre>
                        <mods:typeOfResource>text</mods:typeOfResource>
                        <mods:accessCondition type="use and reproduction" xlink:href="https://creativecommons.org/publicdomain/mark/1.0/" displayLabel="Public Domain Mark 1.0">pdm</mods:accessCondition>
                        <mods:originInfo>
                            <mods:issuance>monographic</mods:issuance>
                            <xsl:apply-templates mode="mods-origininfo"/>
                        </mods:originInfo>
                        <mods:physicalDescription>
                            <xsl:apply-templates mode="mods-physical"/>
                        </mods:physicalDescription>
                        <xsl:apply-templates mode="mods"/>
                    </mods:mods>
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec> 
    </xsl:template>
 
    <xsl:template match="TEI:altIdentifier[@type='hsp-ID']/TEI:idno" mode="mods">
        <mods:identifier type="HSP">
            <xsl:value-of select="."/>
        </mods:identifier>
    </xsl:template>

    <xsl:template match="TEI:altIdentifier[not(@type='hsp-ID')]" mode="mods"/>
  
    <xsl:template match="TEI:idno" mode="mods">
        <mods:location>
            <mods:shelfLocator>
                <xsl:value-of select="."/>
            </mods:shelfLocator>
        </mods:location>
    </xsl:template>
    
    <xsl:template match="TEI:msPart" mode="#all"/>
    
    <xsl:template match="TEI:index[@indexName='norm_title']" mode="mods">
        <mods:titleInfo>
            <mods:title>
                <xsl:value-of select="TEI:term[@type='title']"/>
            </mods:title>
        </mods:titleInfo> 
    </xsl:template>
    
    <xsl:template match="TEI:listBibl/TEI:bibl/TEI:ref" mode="mods">
        <mods:location>
            <mods:url displayLabel="Ausführliche Beschreibung">
                <xsl:value-of select="concat('https://handschriftenportal.de/search?hspobjectid=',@target)"/>
            </mods:url>
        </mods:location>
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName='norm_measure']" mode="mods-physical">
        <mods:extent>
            <xsl:value-of select="TEI:term[@type='measure']"/>
        </mods:extent>
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName='norm_material']" mode="mods-physical">
        <mods:form type="material">
            <xsl:value-of select="TEI:term[@type='material']"/>
        </mods:form>
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName='norm_origDate']" mode="mods-origininfo">
        <mods:dateIssued>
            <xsl:value-of select="TEI:term[@type='origDate']"/>
        </mods:dateIssued>
        <mods:dateIssued encoding="w3cdtf" point="start" keyDate="yes">
            <xsl:value-of select="TEI:term[@type='origDate_notBefore']"/>
        </mods:dateIssued>
        <mods:dateIssued encoding="w3cdtf" point="end">
            <xsl:value-of select="TEI:term[@type='origDate_notAfter']"/>
        </mods:dateIssued>
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
   
    <xsl:template match="TEI:msDesc" mode="map">
        <xsl:message>
            <xsl:text>Map: </xsl:text>
            <xsl:value-of select="@xml:id"/>
        </xsl:message>
        <mets:div TYPE="document" DMDID="{concat('md-',@xml:id)}" LABEL="Handschrift"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="#all"/>
    
</xsl:stylesheet>