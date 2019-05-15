<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
    xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
    xmlns:d2j="http://eirikhanssen.no/doc2jats"
    exclude-result-prefixes="xs f w pkg wp d2j"
    version="2.0">
    
    <xsl:template name="part">
        <xsl:param name="epath"/><!-- path to unzipped docx-archive (external path) -->
        <xsl:param name="ipath"/><!-- path to resource within docx-archive (internal path) -->
        <pkg:part pkg_name="{$ipath}">
            <pkg:xmlData>
                <xsl:sequence select="doc(concat($epath,$ipath))"></xsl:sequence>
            </pkg:xmlData>
        </pkg:part>
    </xsl:template>
    
    <xsl:function name="f:getListNumberFormat" as="text()">
        <xsl:param name="item" as="node()"></xsl:param>
        <xsl:variable name="ilvl" select="$item/w:pPr/w:numPr/w:ilvl/@w:val"/>
        <xsl:variable name="numId" select="$item/w:pPr/w:numPr/w:numId/@w:val"/>
        <xsl:variable name="abstractNumId" select="$item/ancestor::pkg:package/pkg:part/pkg:xmlData/w:numbering/w:num[@w:numId = $numId]/w:abstractNumId/@w:val"/>
        <xsl:variable name="format" select="$item/ancestor::pkg:package/pkg:part/pkg:xmlData/w:numbering/w:abstractNum[@w:abstractNumId = $abstractNumId]/w:lvl[@w:ilvl = $ilvl]/w:numFmt/@w:val"/>
        <xsl:value-of select="$format"/>
    </xsl:function>
    
    <xsl:function name="f:nameFromStyle" as="text()">
        <xsl:param name="node" as="node()"></xsl:param>
        
        <xsl:variable name="pStyle" select="string($node/w:pPr/w:pStyle/@w:val)"/>
        
        <xsl:variable name="styleMapping">
            <stylemapping>
                <rename to="title">
                    <style>Heading1</style>
                </rename>
                <rename to="h2">
                    <style>Heading2</style>
                </rename>
                <rename to="h3">
                    <style>Heading3</style>
                </rename>
                <rename to="h4">
                    <style>Heading4</style>
                </rename>
                <rename to="keywords">
                    <style>Keywords</style>
                </rename>
                <rename to="authors">
                    <style>Forfattere</style>
                    <style>Authors</style>
                </rename>
                <rename to="abstract">
                    <style>Abstrakt</style>
                    <style>Abstract</style>
                </rename>
                <rename to="li">
                    <style>ListParagraph</style>
                </rename>
                <rename to="blockquote">
                    <style>Blokksitat</style>
                    <style>Blockquote</style>
                    <style>Quotations</style>
                </rename>
            </stylemapping>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$pStyle = $styleMapping//style">
                <xsl:value-of select="$styleMapping/stylemapping/rename[$pStyle=style]/@to"/>
            </xsl:when>
            <xsl:otherwise>unknown-style</xsl:otherwise>
        </xsl:choose>
        
    </xsl:function>

    <xsl:template name="elementFromStyle" as="node()">
        <xsl:param name="source-element" as="node()"></xsl:param>
        
        <xsl:variable name="pStyle" select="string($source-element/w:pPr/w:pStyle/@w:val)"/>
        
        <xsl:variable name="new-name" select="f:nameFromStyle($source-element)"/>
        
        <xsl:variable name="has-known-style" select="$new-name ne 'unknown-style'"/>
        
        <xsl:choose>
            <xsl:when test="$has-known-style">
                <xsl:choose>
                    <xsl:when test="$new-name = ('abstract','blockquote')"><xsl:element name="{$new-name}"><p><xsl:apply-templates></xsl:apply-templates></p></xsl:element></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$new-name}">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pStyle = ''"><p><xsl:apply-templates/></p></xsl:when>
            
            <xsl:otherwise>
                  <p data-paragraph-style="{$pStyle}">
                      <xsl:apply-templates/>
                  </p>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="tableElementFromStyle" as="node()">
        <xsl:param name="source-element" as="node()"></xsl:param>
        
        <xsl:variable name="pStyle" select="string($source-element/w:pPr/w:pStyle/@w:val)"/>
        
        <xsl:variable name="new-name" select="f:nameFromStyle($source-element)"/>
        
        <xsl:variable name="has-known-style" select="$new-name ne 'unknown-style'"/>
        
        <xsl:choose>
            <xsl:when test="$has-known-style">
                <xsl:choose>
                    <xsl:when test="$new-name = ('abstract','blockquote')"><xsl:element name="{$new-name}"><p><xsl:apply-templates></xsl:apply-templates></p></xsl:element></xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="{$new-name}">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$pStyle = ''"><p><xsl:apply-templates/></p></xsl:when>
            
            <xsl:otherwise>
                <p data-paragraph-style="{$pStyle}">
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <!-- default identity transform: copy node as is -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>    
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>