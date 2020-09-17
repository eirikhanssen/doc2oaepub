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
    
    <xsl:function name="f:getStringForIDCreation" as="text()">
        <xsl:param name="reference" as="node()"></xsl:param>
        <xsl:variable name="referencePlainText" select="string($reference)"/>
        <xsl:variable name="stringForIDCreation" select="replace($referencePlainText, '^(.+?\((\d+\w?)\)\.).+$','$1')"/>
        <xsl:value-of select="$stringForIDCreation"/>
    </xsl:function>
    
    <xsl:function name="f:countAuthorsInRef" as="xs:int">
        <!-- the input string should be the first text node of a reference paragraph -->
        <xsl:param name="str_reference_beginning" as="text()"/>
        <!-- "Autor, D., Levy, F., &amp; Murnane, R. (2003). The skill content of recent technological change: An empirical exploration." -->

        <!-- keep the authors, and delete everything beginning with the first parens -->
        <xsl:variable name="authors1" select="replace($str_reference_beginning, '^([^(]+)\(.+$', '$1')"/>
        <!-- "Autor, D., Levy, F., &amp; Murnane, R. " -->   
        
        <!-- replace ampersand with a comma-->
        <xsl:variable name="authors2" select="replace($authors1, '&amp;', ',')"/>
        <!-- "Autor, D., Levy, F., , Murnane, R. " -->
        
        <!-- remove initials (Capital letter followed by a period) -->
        <xsl:variable name="authors3" select="replace($authors2, '\p{Lu}[.]','')"/>
        <!-- "Autor, , Levy, , , Murnane,  " -->
            
        <!-- remove all spaces -->
        <xsl:variable name="authors4" select="replace($authors3, '\s+', '')"/>
        <!-- "Autor,,Levy,,,Murnane," -->
        
        <!-- replace consequtive commas with a single comma -->
        <xsl:variable name="authors5" select="replace($authors4, ',+',',')"/>
        <!-- "Autor,Levy,Murnane," -->

        <!-- delete all characters that are not a comma -->
        <xsl:variable name="authors6" select="replace($authors5, '[^,]','')"/>
        <!-- ",,," -->
            
        <!-- count the number of commas (the string length) and you have the number of authors -->
        <xsl:value-of select="string-length($authors6)"/>
        <!-- 3 authors. A value of 0 would indicate that author is Anonymous or an organization -->
    </xsl:function>
    
    <xsl:function name="f:generateIDFromString" as="text()">
        <xsl:param name="input" as="text()"></xsl:param>
        <xsl:variable name="year" select="replace($input, '^.+?(\d{4}\w?).*$','$1')"/>
        <!-- Delete all text except Surnames (words that begin with uppercase letter, followed by lower case letters -->
        <xsl:variable name="significantNames" select="replace($input, '(\s+[\p{Lu}]\p{P}+)|(\p{Z})|(&amp;)|(\p{P})|(\d)|(\p{M})','')"/>
        <xsl:variable name="id" select="concat($significantNames, $year)"/>
        <xsl:value-of select="$id"/>
    </xsl:function>

    <xsl:function name="f:generateHeadingIdFromElementContents">
        <xsl:param name="element" as="node()"></xsl:param>
        <xsl:param name="sequenceNum" as="xs:string"></xsl:param>
        <!-- replace spaces with UnDeRsCoRe -->
        <xsl:variable name="idText0" select="replace(string($element), '\p{Z}+','UnDeRsCoRe')"/>
        <!-- delete marks and punctuation -->
        <xsl:variable name="idText1" select="replace(string($idText0), '(\p{P})|(\p{M})','')"/>
        <!-- replace UnDeRsCoRe with _ and make the string lower-case-->
        <xsl:variable name="idText" select="lower-case(replace($idText1, 'UnDeRsCoRe','_'))"/>
        <xsl:value-of select="concat($sequenceNum, '-', $idText)"/>
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
                    <style>NJSR-Quotations</style>
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