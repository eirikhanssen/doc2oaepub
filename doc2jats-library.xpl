<?xml version="1.0" encoding="UTF-8"?>
<p:library version="1.0" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:d2j="http://eirikhanssen.no/doc2jats" 
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">

    <p:declare-step type="d2j:docx-root" name="docx-root">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        
        <p:input port="source"/>
        
        <p:replace match="/root">
            <p:input port="replacement"><p:inline>
                <pkg:package 
                    xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas"
                    xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex"
                    xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex"
                    xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex"
                    xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex"
                    xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex"
                    xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex"
                    xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex"
                    xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex"
                    xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex"
                    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
                    xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink"
                    xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d"
                    xmlns:o="urn:schemas-microsoft-com:office:office"
                    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                    xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships"
                    xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
                    xmlns:v="urn:schemas-microsoft-com:vml"
                    xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing"
                    xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                    xmlns:w10="urn:schemas-microsoft-com:office:word"
                    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                    xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
                    xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml"
                    xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid"
                    xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex"
                    xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup"
                    xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk"
                    xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
                    xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
                    xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"/>
            </p:inline>
            </p:input>
        </p:replace>
        
        <!-- ============================ -->
        
        <!-- ============================ -->
        
        <p:identity name="final"/>
        
    </p:declare-step>

    <p:declare-step type="d2j:env" name="env">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>

        <p:insert match="/pkg:package" position="first-child">
            <p:input port="insertion">
                <p:inline><env/></p:inline>
            </p:input>
        </p:insert>

        <p:xslt name="xslt">
            <p:input port="source"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:param name="folder" select="'Err: folder is unspecified!'"/>
                        
                        <xsl:template match="/">
                            <xsl:apply-templates/>
                        </xsl:template>
                        
                        <xsl:template match="env">
                            <xsl:copy>
                                <folder><xsl:value-of select="$folder"/></folder>
                            </xsl:copy>
                        </xsl:template>
                    </xsl:stylesheet>
                    
                </p:inline>
            </p:input>
            
            
        </p:xslt>

        <!-- ============================ -->
        
        <!-- ============================ -->
        
        <p:identity name="final"/>
        
    </p:declare-step>

</p:library>