<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:input port="source">
        <p:inline>
            <doc>Hello world!</doc>
            
        </p:inline>
    </p:input>
    <p:output port="result"/>
    
    
    
    <p:filter name="body" select="//w:document"></p:filter>
    <p:delete name="remove-bookmarks" match="//w:bookmarkEnd | //w:bookmarkStart"></p:delete>
    
    <!--
    <p:insert name="test" match="w:rPr[w:b]" position="last-child">
        <p:input port="insertion"><p:inline exclude-inline-prefixes="#all"><w:i/></p:inline></p:input>
    </p:insert>-->
    
    <p:xslt name="xslt3" version="2.0">
        <p:input port="source"/>
        
        
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:f="https://eirikhanssen.com/ns/functions" version="2.0">
                    <xsl:import href="docx-flatten-functions.xsl"/>
                    <xsl:strip-space elements="*"/>
                    <!-- translate paragraph elements depending on style name -->
                    
                    <xsl:template match="w:p">
                        <xsl:call-template name="elementFromStyle">
                            <xsl:with-param name="source-element" select="."/>
                        </xsl:call-template>
                    </xsl:template>
                    
                    <xsl:template match="w:tc">
                        <xsl:call-template name="tableElementFromStyle">
                            <xsl:with-param name="source-element" select="."/>
                        </xsl:call-template>
                    </xsl:template>
                    
                    <xsl:template match="w:r">
                        <xsl:choose>
                            <xsl:when test=".[w:rPr[w:i][w:b]]">
                                <bold><italic><xsl:apply-templates/></italic></bold>
                            </xsl:when>
                            <xsl:when test=".[w:rPr[w:i]]">
                                <italic><xsl:apply-templates/></italic>
                            </xsl:when>
                            <xsl:when test=".[w:rPr[w:b]]">
                                <bold><xsl:apply-templates/></bold>
                            </xsl:when>
                            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:template>
                    
                    <xsl:template match="w:t"><xsl:apply-templates/></xsl:template>
                    
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        <p:input port="parameters">
            <p:pipe port="parameters" step="flatten"/>
        </p:input>
    </p:xslt>
    
    <p:rename match="w:tc[p/@style='TabellKolonneoverskrift']|w:tc[p/@style='TabellRadoverskrift']" new-name="th"></p:rename>
    <p:rename match="w:tc" new-name="td"></p:rename>
    
    <p:rename match="w:tr" new-name="tr"></p:rename>
    <p:rename match="w:tbl" new-name="table"></p:rename>
    <p:delete match="w:rPr|w:lastRenderedPageBreak|w:tcPr|tr/@*|w:tblGrid|w:tblPr|w:proofErr"></p:delete>
    <!-- w:tblPr kanskje noen attributter her som trengs for å finne ut hva slags type tabell -->
    
    
    <!--
    <p:sink>
        <p:input port="source">
            <p:pipe port="result" step="xslt3"></p:pipe>
        </p:input>
    </p:sink>-->
    
    <p:xslt name="strip-whitespace" version="2.0">
        <p:input port="source"/>
        <p:input port="parameters"><p:empty/></p:input>
        <p:input port="stylesheet">
            <p:inline>
                <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:f="https://eirikhanssen.com/ns/functions" version="2.0">
                    <xsl:import href="docx-flatten-functions.xsl"/>
                    <xsl:strip-space elements="*"/>
                    <!-- translate paragraph elements depending on style name -->
                    
                    
                </xsl:stylesheet>
            </p:inline>
        </p:input>
        
    </p:xslt>
    
    <p:identity/>
</p:declare-step>