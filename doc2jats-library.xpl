<?xml version="1.0" encoding="UTF-8"?>
<p:library version="1.0" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:d2j="http://eirikhanssen.no/doc2jats" 
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
    
    <p:declare-step type="d2j:docx-root" name="docx-root">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        
        <p:input port="source"/>
        
        <p:replace match="/root">
            <p:input port="replacement">
                <p:inline>
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
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:docx-flatten" name="docx-flatten">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt name="xslt1" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:param name="folder" select="folder"/>
                        <xsl:strip-space elements="*"/>
                        
                        <xsl:template match="/pkg:package">
                            <xsl:copy>
                                <xsl:copy-of select="node() | @*"/>
                                <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="'/_rels/.rels'"/></xsl:call-template>
                                <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="'/word/_rels/document.xml.rels'"/></xsl:call-template>
                            </xsl:copy>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            
        </p:xslt> <!-- xslt1 -->
        
        <p:xslt name="xslt2" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:param name="folder"/>
                        <xsl:strip-space elements="*"/>
                        <!--<xsl:variable name="test"><xsl:sequence select="//pkg:part[@pkg_name='/_rels/.rels']//rp:Relationship[not(@TargetMode='External')]/string(@Target)"/></xsl:variable>-->
                        <!--<xsl:variable name="rels"><xsl:sequence select="string(pkg:part[@pkg_name='/_rels/.rels']//@*)"></xsl:sequence></xsl:variable>-->
                        <xsl:template match="/pkg:package">
                            <xsl:copy>
                                <xsl:copy-of select="node() | @*"/>
                                <!-- 
                                    <xsl:for-each select="$rels/@pkg_name">
                                    <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="."/></xsl:call-template>    
                                    </xsl:for-each>
                                -->
                                <xsl:for-each select="//pkg:part[@pkg_name='/_rels/.rels']//rp:Relationship[not(@TargetMode='External')]/string(@Target)">
                                    <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="concat('/',.)"/></xsl:call-template>
                                </xsl:for-each>
                                
                                <xsl:for-each select="//pkg:part[@pkg_name='/word/_rels/document.xml.rels']//rp:Relationship[not(@TargetMode='External')][@Type != 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image'][@Type != 'http://schemas.microsoft.com/office/2007/relationships/hdphoto']/string(@Target)">
                                    <xsl:call-template name="part"><xsl:with-param name="epath" select="$folder"/><xsl:with-param name="ipath" select="concat('/word/',.)"/></xsl:call-template>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt> <!-- xslt2 -->
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:filter-w-document" name="filter-w-document">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:filter name="document" select="//pkg:part[@pkg_name='/word/document.xml']/pkg:xmlData/w:document"></p:filter>
        
        <p:delete name="remove-bookmarks" match="w:bookmarkStart|w:bookmarkEnd"></p:delete>
        
        <p:delete name="remove-lang" match="w:lang"/>
        
        <p:delete match="w:proofErr" name="remove-proofErr"/>
        
        <p:identity name="final"/>
    </p:declare-step>
    
    <p:declare-step type="d2j:flat-docx-to-html" name="docx-flatten">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt name="translate-to-html-elements" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        version="2.0"
                        exclude-result-prefixes="f">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:strip-space elements="*"/>
                        
                        <xsl:template match="w:r">
                            <xsl:choose>
                                <xsl:when test=".[w:rPr[w:i][w:b]]">
                                    <strong><em><xsl:apply-templates/></em></strong>
                                </xsl:when>
                                <xsl:when test=".[w:rPr[w:i]]">
                                    <em><xsl:apply-templates/></em>
                                </xsl:when>
                                <xsl:when test=".[w:rPr[w:b]]">
                                    <strong><xsl:apply-templates/></strong>
                                </xsl:when>
                                <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:template>
                        
                        <xsl:template match="w:t"><xsl:apply-templates/></xsl:template>
                        
                        <xsl:template match="w:p">
                            <xsl:element name="p">
                                <xsl:if test="w:pPr/w:pStyle/@w:val">
                                    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val"/>
                                    <!--                                    <xsl:variable name="currentstyle" select="./ancestor::pkg:package/pkg:part/pkg:xmlData/w:styles/w:style[@styleId = $styleId]"/>-->
                                    <xsl:variable name="currentstyle" select="./ancestor::pkg:package/pkg:part/pkg:xmlData/w:styles/w:style[@w:styleId = $styleId]"/>
                                    <!--                                    <xsl:variable name="stylename" select="$currentstyle/w:name/@w:val"/>-->
                                    <xsl:variable name="stylename" select="$currentstyle/w:name/@w:val"/>
                                    <xsl:attribute name="styleId" select="$styleId"/>
                                    <xsl:attribute name="stylename" select="$stylename"/>
                                    <xsl:if test="$currentstyle/w:pPr/w:outlineLvl">
                                        <xsl:variable name="outlinelvl" select="$currentstyle/w:pPr/w:outlineLvl/@w:val"/>
                                        <xsl:attribute name="outlinelvl" select="$outlinelvl"/>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:template>
                        
                        <xsl:template match="w:p[w:pPr/w:numPr]">
                            <xsl:element name="li">
                                <xsl:variable name="stylename" select="w:pPr/w:pStyle/@w:val"/>
                                <xsl:variable name="ilvl" select="w:pPr/w:numPr/w:ilvl/@w:val"/>
                                <xsl:variable name="numId" select="w:pPr/w:numPr/w:numId/@w:val"/>
                                <xsl:attribute name="stylename" select="$stylename"></xsl:attribute>
                                <xsl:attribute name="ilvl" select="$ilvl"></xsl:attribute>
                                <xsl:attribute name="numId" select="$numId"></xsl:attribute>
                                <xsl:attribute name="format" select="f:getListNumberFormat(.)"></xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:template>
                        
                        <xsl:template match="w:p/w:pPr"/>
                        
                        <!-- translate paragraph elements depending on style name -->
                        <!--
                            
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
                            
                        -->
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:delete match="w:rPr|w:spacing|w:lastRenderedPageBreak"/>
        
        <p:identity name="final"/>
    </p:declare-step>
    
    <p:declare-step type="d2j:ocf2htmltable">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt name="ocf-table-to-html-table" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        xmlns:pr="http://schemas.openxmlformats.org/package/2006/relationships"
                        xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                        xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                        xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
                        xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
                        exclude-result-prefixes="xs w r pr wp a pic xhtml w14 wps"
                        version="2.0">
                        
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="w:tbl">
                            <xsl:variable name="tablestyle" select="w:tblPr/w:tblStyle/@w:val"/>
                            <table>
                                <xsl:if test="$tablestyle">
                                    <xsl:attribute name="class" select="$tablestyle"/>
                                </xsl:if>
                                <xsl:apply-templates/>
                            </table>
                        </xsl:template>
                        
                        <xsl:template match="w:tc">
                            <xsl:variable name="table_cell_type">
                                <xsl:choose>
                                    <!-- VIRKER IKKE!!!!!!!! -->
                                    <xsl:when test="./ancestor::w:tr[position() = 1]">th</xsl:when>
                                    <xsl:otherwise>td</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:element name="{$table_cell_type}">
                                <!-- Check if cell will span multiple cells -->
                                <xsl:if test="w:tcPr/w:vMerge[@w:val='restart']">
                                    <!-- Calculate cell index with combined cells -->
                                    <xsl:variable name="celindex" select="count(current()/preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)])+sum(current()/preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)" />
                                    <!-- How many combined rows have so far -->
                                    <xsl:variable name="restartindex" select="count(current()/../preceding-sibling::w:tr/w:tc[count(preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)])+sum(current()/../preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)=$celindex]/w:tcPr/w:vMerge[@w:val='restart'])" />
                                    <!-- Apply rowspan attribute -->
                                    <xsl:attribute name="rowspan" select="count(current()/../following-sibling::w:tr/w:tc[count(preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)])+sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)=$celindex][count(../preceding-sibling::w:tr/w:tc[count(preceding-sibling::w:tc[not(w:tcPr/w:gridSpan)])+sum(preceding-sibling::w:tc/w:tcPr/w:gridSpan/@w:val)=$celindex]/w:tcPr/w:vMerge[@w:val='restart'])=$restartindex+1]/w:tcPr/w:vMerge[not(@w:val='restart')])+1" />
                                </xsl:if>
                                <xsl:if test="w:tcPr/w:gridSpan">
                                    <xsl:attribute name="colspan" select="w:tcPr/w:gridSpan/@w:val" />
                                </xsl:if>
                                <xsl:apply-templates/>
                            </xsl:element>
                        </xsl:template>
                        
                        <xsl:template match="w:tr">
                            <tr>
                                <xsl:attribute name="data-rid" select="generate-id(.)"/>
                                <!-- Apply template to cells which are not merged -->
                                <xsl:apply-templates select="w:trPr|w:tc[not(w:tcPr/w:vMerge[not(@w:val='restart')])]">
                                </xsl:apply-templates>
                            </tr>
                        </xsl:template>
                        
                        <xsl:template match="w:tr[1]">
                            <thead>
                            <tr>
                                <xsl:attribute name="data-rid" select="generate-id(.)"/>
                                <!-- Apply template to cells which are not merged -->
                                <xsl:apply-templates select="w:trPr|w:tc[not(w:tcPr/w:vMerge[not(@w:val='restart')])]">
                                </xsl:apply-templates>
                            </tr>
                            </thead>
                        </xsl:template>
                        
                        <!-- maybe some of these can be used for more logic to the tables: -->
                        <xsl:template match="w:tblPr|w:tblGrid|w:trPr"/>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <!-- have extracted rowspan/colspan from w:tcPr, so w:tcPr is no longer needed -->
        <p:delete match="w:tcPr"></p:delete>
    </p:declare-step>
    
    <p:declare-step type="d2j:group-lists">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:wrap match="//li" wrapper="lists" group-adjacent="//li"></p:wrap>
        
        <p:xslt name="group-lists" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        xmlns:pr="http://schemas.openxmlformats.org/package/2006/relationships"
                        xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                        xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                        xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
                        xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
                        exclude-result-prefixes="xs w r pr wp a pic xhtml w14 wps"
                        version="2.0">
                        
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="lists">
                            <xsl:copy>
                                <xsl:for-each-group select="*" group-starting-with="li[position() = 0]">
                                    <xsl:call-template name="grouping">
                                        <xsl:with-param name="input" select="current-group()[position() gt 0]"></xsl:with-param>
                                    </xsl:call-template>
                                </xsl:for-each-group>
                            </xsl:copy>
                            
                        </xsl:template>
                        
                        <!--  
                            https://stackoverflow.com/questions/34301195/xslt-transformation-of-boolean-expressions/34308637#34308637
                            https://stackoverflow.com/questions/42932880/how-do-we-convert-the-nested-lists-in-microsoft-word-docx-file-to-html-with-xslt
                        -->
                        
                        <xsl:template name="grouping">
                            <xsl:param name="input" as="element()*"/>
                            <xsl:if test="exists($input)">
                                <xsl:variable name="level" select="$input[1]/@ilvl"/>
                                <list>
                                    <xsl:for-each-group select="$input" 
                                        group-starting-with="*[@ilvl=$level]">
                                        
                                        <xsl:copy>
                                            <xsl:apply-templates select="@* | node()"/>
                                            <xsl:call-template name="grouping">
                                                <xsl:with-param name="input" 
                                                    select="current-group()[position() gt 1]"/>
                                            </xsl:call-template>
                                        </xsl:copy>
                                        
                                    </xsl:for-each-group>
                                </list>
                            </xsl:if>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:xslt name="cleanup-lists" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        xmlns:pr="http://schemas.openxmlformats.org/package/2006/relationships"
                        xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                        xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
                        xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml"
                        xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"
                        exclude-result-prefixes="xs w r pr wp a pic xhtml w14 wps"
                        version="2.0">
                        
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="lists">
                            <xsl:apply-templates/>
                        </xsl:template>
                        
                        <xsl:template match="list">
                            <xsl:variable name="list_format" select="current()/li[1]/@format"/>
                            <xsl:variable name="list_type">
                                <xsl:choose>
                                    <xsl:when test="$list_format = ('decimal','lowerLetter')">ol</xsl:when>
                                    <xsl:when test="$list_format = ('bullet','none','')">ul</xsl:when>
                                    <xsl:otherwise>ul</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:element name="{$list_type}">
                                <xsl:attribute name="class" select="$list_format"></xsl:attribute>
                                <xsl:apply-templates select="@* | node()"/>
                            </xsl:element>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:delete name="remove-unneeded-li-attributes" match="li/@stylename|li/@ilvl|li/@numId|li/@format"/>
        
    </p:declare-step>
    
</p:library>
