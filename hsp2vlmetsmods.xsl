<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:TEI="http://www.tei-c.org/ns/1.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/METS/ https://www.loc.gov/standards/mets/mets.xsd
    http://www.loc.gov/mods/v3 https://www.loc.gov/standards/mods/v3/mods-3-8.xsd"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:template match="/">
        <mets:mets>
            <xsl:copy-of select="document('')/*/@xsi:schemaLocation"/>
            <mets:metsHdr>
                <mets:agent ROLE="CREATOR">
                    <mets:name>hsp2vlmetsmods-Skript Knepper 07/2025</mets:name>
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
        <xsl:variable name="title" select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:sourceDesc/TEI:msDesc/TEI:head/TEI:index[@indexName='norm_title']/TEI:term[@type='title']"/>
        <xsl:variable name="shelfmark" select="TEI:TEI/TEI:teiHeader/TEI:fileDesc/TEI:sourceDesc/TEI:msDesc/TEI:msIdentifier/TEI:idno"/>
        <xsl:message>
            <xsl:text>MODS: </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> : </xsl:text>
            <xsl:value-of select="$shelfmark"/>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="$title"/>
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
                        <mods:genre authority="marcgt">script</mods:genre>
                        <mods:genre authority="lcgft">script</mods:genre>
                        <mods:typeOfResource>text</mods:typeOfResource>
                        <mods:accessCondition type="use and reproduction" xlink:href="https://creativecommons.org/publicdomain/mark/1.0/" displayLabel="Public Domain Mark 1.0">pdm</mods:accessCondition>
                        <mods:titleInfo>
                            <mods:title>
                                <xsl:value-of select="string-join(($shelfmark,$title),' - ')"/>
                            </mods:title>
                        </mods:titleInfo>
                        <xsl:variable name="recorddatagroup">
                            <xsl:sequence select="$recorddata/*[not(name()='mods:originInfo')]"/>
                            <mods:originInfo>
                                <xsl:variable name="originInfodata">
                                    <xsl:sequence select="$recorddata/mods:originInfo/*"/>
                                </xsl:variable>
                                <xsl:variable name="originInfodatasort">
                                    <xsl:perform-sort select="$originInfodata/*">
                                        <xsl:sort select="name()"/>
                                        <xsl:sort select="@point"/>
                                        <xsl:sort select="mods:placeTerm/@valueURI"/>
                                        <xsl:sort select="text()|*/text()"/>
                                    </xsl:perform-sort>
                                </xsl:variable>
                                <xsl:for-each select="$originInfodatasort/*">
                                    <xsl:if test="not(deep-equal((.),(preceding-sibling::*[1])))">
                                        <xsl:sequence select="."/>
                                    </xsl:if>
                                </xsl:for-each>
                            </mods:originInfo>
                        </xsl:variable>
                        <xsl:variable name="recorddatasort">
                            <xsl:perform-sort select="$recorddatagroup/*">
                                <xsl:sort select="name()"/>
                                <xsl:sort select="string-join(text()|*/text(),'+')"/>
                                <xsl:sort select="mods:url"/>
                            </xsl:perform-sort>
                        </xsl:variable>
                        <xsl:for-each select="$recorddatasort/*">
                            <xsl:if test="not(deep-equal((.),(preceding-sibling::*[1])))">
                                <xsl:sequence select="."/>
                            </xsl:if>
                        </xsl:for-each>
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
            <xsl:when test="@type='hsp:description'"> <!-- Einsprungpunkt zur HS? -->
                <mods:location>
                    <mods:url displayLabel="Beschreibung im Handschriftenportal">
                        <xsl:value-of select="concat('https://handschriftenportal.de/search?hspobjectid=',@xml:id)"/>
                    </mods:url>
                </mods:location>
            </xsl:when>
        </xsl:choose>
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
            <xsl:choose>
                <xsl:when test="../TEI:repository/@ref">
                    <xsl:variable name="valueuri">
                        <xsl:choose>
                            <xsl:when test="contains(../TEI:repository/@ref,'https://d-nb.info/gnd/')">
                                <xsl:value-of select="concat('http://d-nb.info/gnd/',substring-after(../TEI:repository/@ref,'https://d-nb.info/gnd/'))"/>
                            </xsl:when>
                            <xsl:when test="contains(../TEI:repository/@ref,'http://d-nb.info/gnd/')">
                                <xsl:value-of select="../TEI:repository/@ref"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('http://d-nb.info/gnd/',../TEI:repository/@ref)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <mods:physicalLocation authorityURI="http://d-nb.info/gnd/" valueURI="{$valueuri}">
                        <xsl:value-of select="../TEI:repository"/>
                    </mods:physicalLocation>
                </xsl:when>
                <xsl:otherwise>
                    <mods:physicalLocation>
                        <xsl:value-of select="../TEI:repository"/>
                    </mods:physicalLocation> 
                </xsl:otherwise>
            </xsl:choose>
            <mods:shelfLocator>
                <xsl:value-of select="string-join((../TEI:repository,.),' : ')"/>
            </mods:shelfLocator>
        </mods:location>
    </xsl:template>
    
    <xsl:template match="TEI:msPart" mode="#all"/>
    
    <xsl:template match="TEI:listBibl/TEI:bibl/TEI:ref[starts-with(@target,'HSP-')]" mode="mods">
        <mods:location>
            <mods:url displayLabel="Beschreibung im Handschriftenportal">
                <xsl:value-of select="concat('https://handschriftenportal.de/search?hspobjectid=',@target)"/>
            </mods:url>
        </mods:location>
    </xsl:template>
    
    <xsl:template match="TEI:history" mode="mods">
        <mods:abstract displayLabel="Beschreibung">
                <xsl:value-of select="normalize-space(.)"/>
        </mods:abstract>
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
        <xsl:if test="not(TEI:term[@type='origPlace_norm']/text())"> 
            <xsl:for-each select="TEI:term[@type='origPlace']/text()">
                <mods:place>
                    <mods:placeTerm type="text">
                        <xsl:value-of select="."/>
                    </mods:placeTerm>
                </mods:place>    
             </xsl:for-each>
         </xsl:if>
         <xsl:for-each select="TEI:term[@type='origPlace_norm'][substring-after(@ref,'http://d-nb.info/gnd/')!='']">
             <mods:place> 
                 <mods:placeTerm authorityURI="http://d-nb.info/gnd/" valueURI="{@ref}" type="text">
                    <xsl:value-of select="."/>
                </mods:placeTerm>
             </mods:place>
         </xsl:for-each>
    </xsl:template>
 
    <xsl:template match="TEI:index[@indexName='norm_textLang']/TEI:term[@ref]" mode="mods">
        <xsl:variable name="iso639_2b" select="('ger','lat','ita','fre','cat')"/>
        <xsl:variable name="gnd" select="('http://d-nb.info/gnd/4113292-0','http://d-nb.info/gnd/4114364-4','http://d-nb.info/gnd/4114056-4','http://d-nb.info/gnd/4113615-9','http://d-nb.info/gnd/4120218-1')"/>
        <xsl:variable name="i" select="index-of($gnd,./@ref)"/>
            <xsl:if test="$i>0">
                <mods:language>
                    <mods:languageTerm type="code" authority="iso639-2b">
                        <xsl:value-of select="$iso639_2b[$i]"/>
                     </mods:languageTerm>
                </mods:language>
            </xsl:if>
    </xsl:template>
 
    <xsl:template match="TEI:index[@indexName]/TEI:term/TEI:persName" mode="mods">
            <xsl:choose>
                <xsl:when test="../../@indexName='Autorschaft'">
                    <mods:name type="personal" authorityURI="http://d-nb.info/gnd/" valueURI="{@ref}">
                        <mods:displayForm><xsl:value-of select="."/></mods:displayForm>
                        <mods:role>
                            <mods:roleTerm type="code" authority="marcrelator">aut</mods:roleTerm>
                            <mods:roleTerm>author</mods:roleTerm>
                        </mods:role>
                    </mods:name>
                </xsl:when>
                <xsl:when test="../../@indexName=('Herstellung') or (../../@indexName='Kommentar')">
                    <mods:name type="personal" authorityURI="http://d-nb.info/gnd/" valueURI="{@ref}">
                        <mods:displayForm><xsl:value-of select="."/></mods:displayForm>
                        <mods:namePart><xsl:value-of select="."/></mods:namePart>
                        <mods:role>
                            <mods:roleTerm type="code" authority="marcrelator">ctb</mods:roleTerm>
                            <mods:roleTerm>contributor</mods:roleTerm>
                        </mods:role>
                    </mods:name>
                </xsl:when>
                <xsl:when test="../../@indexName='Erwähnung'">
                    <mods:subject>
                        <mods:name type="personal" authorityURI="http://d-nb.info/gnd/" valueURI="{@ref}">
                            <mods:displayForm><xsl:value-of select="."/></mods:displayForm>
                            <mods:namePart><xsl:value-of select="."/></mods:namePart>
                        </mods:name>
                    </mods:subject>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Person: unbekannte Rolle <xsl:value-of select="../../@indexName"/></xsl:message>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

    <xsl:template match="TEI:index[@indexName]/TEI:term[@type='6920']" mode="mods">
        <mods:genre><xsl:value-of select="."/></mods:genre>
    </xsl:template>
    
    <xsl:template match="TEI:index[@indexName]/TEI:term[(@type='6930') or (@type='6930gi') or (@type='6922')]" mode="mods">
        <mods:subject><mods:topic><xsl:value-of select="."/></mods:topic></mods:subject>
    </xsl:template>

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