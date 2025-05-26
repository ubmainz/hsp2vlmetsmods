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
                    <mets:name>hsp2vlmetsmods-Skript Knepper 05/2025</mets:name>
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
 
    <xsl:template match="record" mode="mods">
        <xsl:variable name="id" select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:sourceDesc/TEI:msDesc/@xml:id"/>
        <xsl:message>
            <xsl:text>MODS: </xsl:text>
            <xsl:value-of select="$id"/>
        </xsl:message>
        <xsl:variable name="recorddata">
            <xsl:apply-templates mode="mods"/>
        </xsl:variable>
        <mets:dmdSec ID="{concat('md-',$id)}">
            <mets:mdWrap MIMETYPE="text/xml" MDTYPE="MODS">
                <mets:xmlData>
                    <mods:mods>
                        <mods:recordInfo>
                            <mods:recordIdentifier>
                                <xsl:value-of select="$id"/>
                            </mods:recordIdentifier>
                        </mods:recordInfo>
                        <xsl:perform-sort select="$recorddata/*">
                            <xsl:sort select="name()"/>
                        </xsl:perform-sort>
                    </mods:mods>
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec> 
    </xsl:template>
 
    <xsl:template match="TEI:msDesc" mode="mods">
        <xsl:if test="not(TEI:msIdentifier/TEI:idno/text())">
            <xsl:message>
                <xsl:text>Warnung: keine Signatur</xsl:text>
            </xsl:message>
        </xsl:if>
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
        <mods:genre authority="lcgft">script</mods:genre>
        <mods:typeOfResource>text</mods:typeOfResource>
        <mods:accessCondition type="use and reproduction" xlink:href="https://creativecommons.org/publicdomain/mark/1.0/" displayLabel="Public Domain Mark 1.0">pdm</mods:accessCondition>
        <mods:originInfo>
            <mods:issuance>monographic</mods:issuance>
            <xsl:apply-templates mode="mods-origininfo"/>
        </mods:originInfo>
        <mods:physicalDescription>
            <mods:extent>
                <xsl:value-of select="string-join((.//TEI:index[@indexName='norm_measure']/TEI:term[@type='measure']/text(),
                .//TEI:index[@indexName='norm_material']/TEI:term[@type='material']/text(),
                .//TEI:index[@indexName='norm_dimensions']/TEI:term[@type='dimensions']/text()),' ; ')"/>
            </mods:extent>
        </mods:physicalDescription>
        <xsl:apply-templates mode="mods"/>
        <xsl:if test="not(.//TEI:index[@indexName='norm_textLang'])">
            <mods:language>
                <mods:languageTerm type="code" authority="iso639-2b">
                    <xsl:text>lat</xsl:text>
                </mods:languageTerm>
            </mods:language>    
        </xsl:if>
    </xsl:template>
 
    <xsl:template match="TEI:altIdentifier[@type='hsp-ID']/TEI:idno" mode="mods">
        <mods:identifier type="HSP">
            <xsl:value-of select="."/>
        </mods:identifier>
    </xsl:template>

    <xsl:template match="TEI:altIdentifier[not(@type='hsp-ID')]" mode="mods"/>
  
    <xsl:template match="TEI:idno" mode="mods">
        <mods:location>
            <mods:physicalLocation authorityURI="http://d-nb.info/gnd/" valueURI="http://d-nb.info/gnd/{../TEI:repository/@ref}">
                <xsl:value-of select="../TEI:repository"/>
            </mods:physicalLocation>
            <mods:shelfLocator>
                <xsl:value-of select="string-join((../TEI:repository,.),' : ')"/>
            </mods:shelfLocator>
        </mods:location>
    </xsl:template>
    
    <xsl:template match="TEI:msPart" mode="#all"/>
    
    <xsl:template match="TEI:index[@indexName='norm_title']" mode="mods">
        <mods:titleInfo>
            <mods:title>
                <xsl:value-of select="string-join((../../TEI:msIdentifier/TEI:idno,TEI:term[@type='title']),' - ')"/>
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
         <xsl:for-each select="TEI:term[@type='origPlace']">
            <mods:place>
                <mods:placeTerm type="text">
                    <xsl:value-of select="."/>
                </mods:placeTerm>
            </mods:place>    
         </xsl:for-each>
         <xsl:for-each select="TEI:term[@type='origPlace_norm'][starts-with(@ref,'http://d-nb.info/gnd/')]">
             <mods:place> 
                <mods:placeTerm authorityURI="http://d-nb.info/gnd/" valueURI="{@ref}"/>
                <mods:placeTerm type="text">
                    <xsl:value-of select="."/>
                </mods:placeTerm>
             </mods:place>
         </xsl:for-each>
    </xsl:template>
 
    <xsl:template match="TEI:index[@indexName='norm_textLang']/TEI:term[@type='textLang-ID']" mode="mods">
        <xsl:variable name="iso639_1" select="('de','la','it','fr','ca')"/>
        <xsl:variable name="iso639_2b" select="('ger','lat','ita','fre','cat')"/>
        <xsl:variable name="i" select="index-of($iso639_1,.)"/>
            <xsl:if test="$i>0">
                <mods:language>
                    <mods:languageTerm type="code" authority="iso639-2b">
                        <xsl:value-of select="$iso639_2b[$i]"/>
                     </mods:languageTerm>
                </mods:language>
            </xsl:if>
    </xsl:template>
 
 <!--
    <xsl:template match="TEI:index[indexName='Autorschaft']/TEI:term[@type='textLang-ID']" mode="mods">
        <name type="personal" authorityURI="http://d-nb.info/gnd/" valueURI="http://d-nb.info/gnd/118522213">
        <displayForm>Cornelius, Peter</displayForm>
        <namePart>Cornelius, Peter</namePart>
        <role>
            <roleTerm type="code" authority="marcrelator">aut</roleTerm>
            <roleTerm>author</roleTerm>
        </role>
    </name>
    </xsl:template>
 -->   
 
    <xsl:template match="record" mode="map">
        <xsl:variable name="id" select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:sourceDesc/TEI:msDesc/@xml:id"/>
        <xsl:message>
            <xsl:text>Map: </xsl:text>
            <xsl:value-of select="$id"/>
        </xsl:message>
        <mets:div TYPE="document" DMDID="{concat('md-',$id)}" LABEL="Handschrift"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="#all"/>
    
</xsl:stylesheet>