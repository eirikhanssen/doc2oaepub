<?xml version="1.0" encoding="UTF-8"?>
<p:library version="1.0" 
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:d2j="http://eirikhanssen.no/doc2jats" 
    xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing">
    
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
                        xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes"
                        />
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
                        <xsl:param name="input_folder"/>
                        
                        <xsl:template match="/">
                            <xsl:apply-templates/>
                        </xsl:template>
                        
                        <xsl:template match="env">
                            <xsl:copy>
                                <folder><xsl:value-of select="$input_folder"/></folder>
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
                        <xsl:param name="input_folder"/>
                        <xsl:strip-space elements="*"/>
                        
                        <xsl:template match="/pkg:package">
                            <xsl:copy>
                                <xsl:copy-of select="node() | @*"/>
                                <xsl:call-template name="part"><xsl:with-param name="epath" select="$input_folder"/><xsl:with-param name="ipath" select="'/_rels/.rels'"/></xsl:call-template>
                                <xsl:call-template name="part"><xsl:with-param name="epath" select="$input_folder"/><xsl:with-param name="ipath" select="'/word/_rels/document.xml.rels'"/></xsl:call-template>
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
                        <xsl:param name="input_folder"/>
                        <xsl:strip-space elements="*"/>
                        
                        <xsl:template match="/pkg:package">
                            <xsl:copy>
                                <xsl:copy-of select="node() | @*"/>
                        
                                <xsl:for-each select="//pkg:part[@pkg_name='/_rels/.rels']//rp:Relationship[not(@TargetMode='External')]/string(@Target)">
                                    <xsl:call-template name="part"><xsl:with-param name="epath" select="$input_folder"/><xsl:with-param name="ipath" select="concat('/',.)"/></xsl:call-template>
                                </xsl:for-each>
                                
                                <xsl:for-each select="//pkg:part[@pkg_name='/word/_rels/document.xml.rels']//rp:Relationship[not(@TargetMode='External')][@Type != 'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image'][@Type != 'http://schemas.microsoft.com/office/2007/relationships/hdphoto']/string(@Target)">
                                    <xsl:call-template name="part"><xsl:with-param name="epath" select="$input_folder"/><xsl:with-param name="ipath" select="concat('/word/',.)"/></xsl:call-template>
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
                        
                        <xsl:template match="w:r|w:t"><xsl:apply-templates/></xsl:template>
                        
                        <xsl:template match="w:p">
                            <xsl:choose>
                                <xsl:when test="w:pPr/w:pStyle/@w:val">
                                    <xsl:variable name="styleId" select="w:pPr/w:pStyle/@w:val"/>
                                    <xsl:variable name="currentstyle" select="./ancestor::pkg:package/pkg:part/pkg:xmlData/w:styles/w:style[@w:styleId = $styleId]"/>
                                    <xsl:variable name="styleName" select="$currentstyle/w:name/@w:val"/>
                                    <xsl:variable name="styleId" select="$styleId"/>
                                    <xsl:variable name="styleName" select="$styleName"/>
                                    <xsl:variable name="outlinelvl" select="$currentstyle/w:pPr/w:outlineLvl/@w:val"/>
                                    
                                    <xsl:variable name="el_name">
                                        <xsl:choose>
                                            <xsl:when test="$outlinelvl"><xsl:value-of select="concat('h' , $outlinelvl+1)"/></xsl:when>
                                            <xsl:otherwise>p</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    
                                    <xsl:element name="{$el_name}">
                                        <xsl:if test="not(matches($el_name, '^h'))">
                                            <xsl:attribute name="styleId" select="$styleId"/>
                                            <xsl:attribute name="styleName" select="$styleName"/>
                                        </xsl:if>
                                        <xsl:apply-templates/>
                                    </xsl:element>				    
                                </xsl:when>
                                <xsl:otherwise>
                                    <p><xsl:apply-templates/></p>
                                </xsl:otherwise>
                            </xsl:choose>
                            
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
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        
        <p:xslt name="rename-elements-based-on-styleId-and-other-criteria" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                        xmlns:r="http://schemas.openxmlformats.org/package/2006/relationships"
                        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
                        
                        version="2.0"
                        exclude-result-prefixes="f a r mc">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:strip-space elements="*"/>
                        
                        <xsl:template match="p[matches(@styleId , '^Keywords')]">
                            <xsl:variable name="textcontent"><xsl:apply-templates select=".//text()"/></xsl:variable>
                            <dl class="keywords">
                                <xsl:analyze-string select="$textcontent" regex="^Keywords *([.:])">
                                    <xsl:matching-substring>
                                        <dt><xsl:value-of select="."/></dt>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:variable name="list-of-keywords" select="normalize-space(.)"/>
                                        <xsl:analyze-string select="$list-of-keywords" regex=" *, *">
                                            <xsl:matching-substring/>
                                            <xsl:non-matching-substring>
                                                <xsl:variable name="keyword-item" select="."/>
                                                <dd><xsl:value-of select="$keyword-item"/></dd>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </dl>
                            
                        </xsl:template> 
                        
                        <xsl:template match="p[@styleId][matches(@styleId,'^Reference')]">
                            <p class="ref">
                                <xsl:apply-templates/>
                            </p>
                        </xsl:template>
                        
                        <xsl:template match="p[@styleId][matches(@styleId,'^Abstract')]">
                            <p class="abstract">
                                <xsl:apply-templates/>
                            </p>
                        </xsl:template>
                        
                        <xsl:template match="w:hyperlink">
                            <xsl:variable name="content" select="."/>
                            <xsl:variable name="src">
                                <xsl:if test="matches($content,'@')"><xsl:text>mailto:</xsl:text></xsl:if>
                                <xsl:value-of select="$content"/>
                            </xsl:variable>
                            <a href="{$src}">
                                <xsl:value-of select="$content"/>
                            </a>
                        </xsl:template>

                        <!-- Disabled because it's not working: attempting to set img src to image path (media/image001.png)  -->
                        <!--
                        <xsl:template match="p[w:drawing]">
                            <xsl:variable name="alt" select="w:drawing/wp:inline/wp:docPr/@descr"/>
                            <xsl:variable name="img_rid" select=".//a:blip/@*"/>
                            <xsl:variable name="img" select="ancestor::pkg:package/pkg:part/pkg:xmlData/r:Relationships/r:Relationship[matches(@Id, $img_rid)]/@Target"></xsl:variable>
                            <figure>
                                <img src="{$img}" alt="{$alt}"/>
                                <figcaption>____</figcaption>
                            </figure>
                        </xsl:template>-->
                        
                        <xsl:template match="w:body//p[w:drawing]">
                            <xsl:variable name="alt" select="w:drawing/wp:inline/wp:docPr/@descr"/>
                            <xsl:variable name="preceding-figures" select="count(preceding::p[w:drawing]) + 1"/>
                            <figure>
                                <img src="{concat('figure-',$preceding-figures, '.jpg')}" alt="{$alt}"/>
                                <figcaption>____</figcaption>
                            </figure>
                        </xsl:template>
                        
                        <xsl:template match="p[mc:AlternateContent]">
                            <xsl:copy>
                                <xsl:apply-templates/>
                            </xsl:copy>
                            <figure>
                                <img src="figure.png"/>
                                <figcaption>____</figcaption>
                            </figure>
                        </xsl:template>
                        
                        <xsl:template match="mc:AlternateContent"/>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:delete match="w:rPr|w:spacing|w:lastRenderedPageBreak"/>
        
        <p:identity name="final"/>
    </p:declare-step>
    
    <p:declare-step type="d2j:translate-ocftable-to-initial-htmltable">
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
                                    <xsl:when test="count(parent::w:tr/preceding-sibling::w:tr) &lt; 1">th</xsl:when>
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
                        
                        <!-- maybe some of these can be used for more logic to the tables: -->
                        <xsl:template match="w:tblPr|w:tblGrid|w:trPr"/>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <!-- have extracted rowspan/colspan from w:tcPr, so w:tcPr is no longer needed -->
        <p:delete match="w:tcPr"></p:delete>
    </p:declare-step>
    
    <p:declare-step type="d2j:restructure-tables">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>

        <!-- Note: the order of the following xproc-steps is significant.  -->
        <p:rename match="td[p[matches(@styleId, '^TableHeader')]]" new-name="th"/>
        <p:add-attribute match="th[p[matches(@styleId, 'Center')]]" attribute-name="class" attribute-value="center"/>
        <p:add-attribute match="th[p[matches(@styleId, 'Left')]]" attribute-name="class" attribute-value="left"/>
        <p:delete match="tr/@data-rid"/>
        <p:add-attribute match="td[p[matches(@styleId, 'Narrow')]]" attribute-name="data-style" attribute-value="narrow"/>
        <p:add-attribute match="tr[ (th[1]/@class != 'center') and (th/@class = 'center') and (every $th in th[position() &gt; 1] satisfies $th/@class = 'center') ]" attribute-name="class" attribute-value="left-center"/>
        <p:add-attribute match="tr[ (every $th in th satisfies $th/@class = 'center') ]" attribute-name="class" attribute-value="center"/>
        <p:delete match="p[(matches(@styleId, 'TableHeader')) and (parent::th)]/@*[matches(name(.) , 'style.*')]"/>
        <p:delete match="p[(matches(@styleId, 'TableContents')) and (parent::td)]/@*[matches(name(.) , 'style.*')]"/>
        <p:delete match="th[(matches(@class, 'center')) and (parent::tr[matches(@class, 'center')])]/@class"/>
        <p:delete match="th[(matches(@class, 'left')) and (parent::tr[matches(@class, 'left')])]/@class"/>
        <p:delete match="p[(matches(@styleId, '^Ingen'))]/@*[matches(name(.) , 'style.*')]"/>
        
        <!-- Group into thead and tbody -->
        <p:add-attribute match="tr[ (th and not(td)) and not(preceding-sibling::tr[td])]" attribute-name="grouping" attribute-value="thead"/>
        <p:add-attribute match="tr[not (@grouping)]" attribute-name="grouping" attribute-value="tbody"/>
        <p:wrap match="tr[@grouping='thead']" group-adjacent="local-name(.)" wrapper="thead"></p:wrap>
        <p:wrap match="tr[@grouping='tbody']" group-adjacent="local-name(.)" wrapper="tbody"></p:wrap>
        <p:delete match="tr/@grouping"/>
        
        <p:xslt name="table-caption-and-tfoot" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        
                        exclude-result-prefixes="xs w xhtml"
                        version="2.0">
                        
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="table[preceding-sibling::*[1][self::p][matches(@styleId, '^TableCaption')]]">
                            <xsl:variable name="caption" select="preceding-sibling::*[1][self::p][matches(@styleId, '^TableCaption')]"/>
                            <xsl:copy>
                                <xsl:copy-of select="@*"/>
                                <caption><xsl:apply-templates mode="caption" select="$caption"/></caption>
                                <xsl:apply-templates/>
                                <xsl:if test="following-sibling::*[1][self::p[matches(@styleId, '^TableNotes')]]">
                                    <tfoot class="table-notes">
                                        <xsl:apply-templates mode="tfoot" select="following-sibling::*[1][self::p[matches(@styleId, '^TableNotes')]]"></xsl:apply-templates>
                                    </tfoot>
                                </xsl:if>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template mode="caption" match="p[matches(@styleId, 'TableCaption')][following-sibling::*[1][self::table]]">
                            <xsl:copy><xsl:apply-templates/></xsl:copy>
                        </xsl:template>
                        
                        <xsl:template mode="tfoot" match="p[matches(@styleId, '^TableNotes')]">
                            <xsl:copy><xsl:apply-templates/></xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="p[matches(@styleId, 'TableCaption')][following-sibling::*[1][self::table]]"/>
                        <xsl:template match="p[matches(@styleId, '^TableNotes')][preceding-sibling::*[1][self::table]]"/>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
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
                                    <xsl:when test="$list_format = ('decimal','lowerLetter','lowerRoman')">ol</xsl:when>
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
    
    <p:declare-step type="d2j:replace-symbols">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt name="replace-symbols-xsl" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        
                        exclude-result-prefixes="xs w xhtml"
                        version="2.0">
                        
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <w:sym w:font="Wingdings" w:char="F0E0"/>
                        <xsl:template match="w:sym">
                            <!-- replace a word entity with the "right arrow" symbol -->
                            <xsl:choose>
                                <xsl:when test="@w:char = 'F0E0'"><xsl:text>🡒</xsl:text></xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy>
                                        <xsl:copy-of select="@*|node()"/>
                                    </xsl:copy>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:restructure-figures">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt name="restructure-figures" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        
                        exclude-result-prefixes="xs w xhtml"
                        version="2.0">
                        
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="figcaption[parent::figure/following-sibling::p[matches(@styleId, '^FigureCaption')]]">
                            <xsl:variable name="figure_parent" select="parent::figure"/>
                            <figcaption><xsl:apply-templates mode="figcaption" select="parent::figure/following-sibling::p[matches(@styleId, '^FigureCaption')][generate-id(preceding-sibling::figure[1]) = generate-id($figure_parent)]"></xsl:apply-templates></figcaption>
                        </xsl:template>    
                        
                        <xsl:template mode="figcaption" match="p[matches(@styleId, '^FigureCaption')]"><p><xsl:apply-templates/></p></xsl:template>
                        
                        <xsl:template match="p[(matches(@styleId, '^FigureCaption')) and preceding-sibling::*[1][self::figure]]"/>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:rename-elements">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        
        <p:xslt name="rename_elements" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
                        exclude-result-prefixes="xs w mc pkg"
                        version="2.0">
                        <xsl:template match="p[matches(@styleId, '.*[rR]eference.*')]">
                            <xsl:copy>
                                <xsl:attribute name="class">reference</xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:copy>
                        </xsl:template>

                        <xsl:template match="@* | node()">
                            <xsl:copy copy-namespaces="no">
                                <xsl:apply-templates select="@* | node()"/>
                            </xsl:copy>
                        </xsl:template>
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:namespace-rename from="http://schemas.openxmlformats.org/wordprocessingml/2006/main" to=""/>
        <p:namespace-rename from="http://schemas.openxmlformats.org/markup-compatibility/2006" to=""/>
        <p:delete match="document/@*"/>
        <p:rename match="document" new-name="html"></p:rename>
        <p:add-attribute match="html" name="lang" attribute-name="lang" attribute-value="en-US"></p:add-attribute>
    </p:declare-step>
    
    <p:declare-step type="d2j:cleanup">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        <p:delete match="w:br[@w:type='page']"/>
        <p:delete match="w:sectPr"/><!-- needed? -->
        <p:delete match="sectPr"/>
        <p:xslt name="replace-symbols-xsl" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xhtml="http://www.w3.org/1999/xhtml"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        exclude-result-prefixes="xs w mc pkg"
                        version="2.0">
                        <xsl:template match="@* | node()">
                            <xsl:copy copy-namespaces="no">
                             <xsl:apply-templates select="@* | node()"/>
                            </xsl:copy>
                        </xsl:template>
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        <!-- unwrap formatting elements with only white space "\p{Z}" and/or punctuation "\p{P}"-->
        <p:unwrap match="em[matches(., '^((\p{Z}+)|(\p{P}))+$')]"></p:unwrap>
        <p:unwrap match="strong[matches(., '^((\p{Z}+)|(\p{P}))+$')]"></p:unwrap>
        <p:namespace-rename from="http://schemas.openxmlformats.org/wordprocessingml/2006/main" to=""/>
        <p:namespace-rename from="http://schemas.openxmlformats.org/markup-compatibility/2006" to=""/>
        <p:delete match="document/@*"/>
        <p:rename match="document" new-name="html"></p:rename>
        <p:add-attribute match="html" name="lang" attribute-name="lang" attribute-value="en-US"></p:add-attribute>
    </p:declare-step>
    
    <p:declare-step type="d2j:html-head" name="html-head"
        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
        exclude-inline-prefixes="d2j pkg w wp">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        <p:insert match="html" position="first-child">
            <p:input port="insertion">
                <p:inline>
                    <head>
                        <meta charset="utf-8"/>
                        <title>Journal Article</title>
                        <link href="https://journals.hioa.no/styles/article.css" rel="stylesheet"/>
                        <script src="https://journals.hioa.no/js/article.js" defer="defer"> </script>
                    </head>
                </p:inline>
            </p:input>
        </p:insert>
        
        <p:xslt name="update-title" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="xs"
                        version="2.0">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="/html/head/title">
                            <xsl:copy>
                                <xsl:variable name="article-title" select="/html/body/h1[1]/text()"/>
                                <xsl:value-of select="concat($article-title, ' | Journal Article')"/>
                            </xsl:copy>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    
    <p:declare-step type="d2j:formatting" name="formatting">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:wrap match="text()[ancestor::w:r[1]/w:rPr/w:b]" wrapper="strong"></p:wrap>
        <p:wrap match="text()[ancestor::w:r[1]/w:rPr/w:i]" wrapper="em"></p:wrap>
        <p:wrap match="text()[ancestor::w:r[1]/w:rPr/w:u]" wrapper="u"></p:wrap>
        <p:wrap match="text()[ancestor::w:r[1]/w:rPr/w:rStyle[matches(@w:val, '^(ReferenceSource)|(Emphasis)')]][not(ancestor::em)]" wrapper="em"></p:wrap>
        <p:wrap match="text()[ancestor::w:r[1]/w:rPr/w:vertAlign/@w:val='superscript']" wrapper="sup"></p:wrap>
        <p:wrap match="text()[ancestor::w:r[1]/w:rPr/w:vertAlign/@w:val='subscript']" wrapper="sub"></p:wrap>
        
        <p:replace match="w:p//w:tab">
            <p:input port="replacement">
                <p:inline>
                    <w:t xml:space="preserve">	</w:t>
                </p:inline>
            </p:input>
        </p:replace>
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:delete-needless-markup" name="delete-needless-markup">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:delete match="w:proofErr"/>
        <p:delete name="remove-bookmarks" match="w:bookmarkStart|w:bookmarkEnd"></p:delete>	
        <p:delete name="remove-lang" match="w:lang"/>
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    
    <p:declare-step type="d2j:author-group" name="author-group">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
    
        <p:xslt name="group-authors" version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet 
                        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="xs"
                        version="2.0">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        
                        
                        <xsl:template match="p[matches(@styleId, '^AuthorName')]">
                            <xsl:variable name="counter" select="count(following-sibling::p)"/>
                            <dl class="author">
                                <dt><xsl:apply-templates/></dt>
                   <!--  !!!! BUGGY CODE !!!!     -->
                   <!--  XPATH selector is wrong below 
                         one author's details is added to all previous authors -->
                                                                
                                <xsl:apply-templates select="following-sibling::p[matches(@styleId, '^AuthorDetails')]" mode="authors"/>
                                
                   <!--  !!!! BUGGY CODE !!!!  -->
                            </dl>
                        </xsl:template>
                        
                        <xsl:template mode="authors" match="p[matches(@styleId, '^AuthorDetails')]">
                            <dd><xsl:apply-templates/></dd>
                        </xsl:template>
                        
                        <xsl:template match="p[matches(@styleId, '^AuthorDetails')]"/>
                            
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>  
    
        <p:identity name="final"/>
    </p:declare-step>
    
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="merge-em" type="d2j:merge-em"
        xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" exclude-inline-prefixes="c">
        <p:serialization port="result" method="xml" indent="true"></p:serialization>
        <p:input port="source"/>
        <p:output port="result"/>
        
        <p:wrap match="text()[not(parent::em)][matches(. ,'^[&#xa; .,:;-]*$')]" wrapper="fmt"/>
        <p:wrap match="text()[not(parent::*[matches(name(.) , '^(em)|(fmt)$')])]" wrapper="txt"></p:wrap>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                        <xsl:template match="node()|@*">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="*[count(child::em) &gt; 1]">
                            <xsl:copy>
                                <xsl:copy-of select="@*"/>
                                <xsl:for-each-group select="*" group-adjacent="boolean(self::em or (self::fmt/preceding-sibling::*[1]/name()='em' and self::fmt/following-sibling::*[1]/name()='em'))">
                                    <xsl:choose>
                                        <xsl:when test="current-grouping-key()">
                                            <em>
                                                <xsl:for-each select="current-group()">
                                                    <xsl:copy-of select="@*"/>
                                                    <xsl:apply-templates select="*|text()"/>
                                                </xsl:for-each>
                                            </em>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="current-group()">
                                                <xsl:apply-templates select="."/>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each-group>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="txt|fmt"><xsl:apply-templates/></xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity/>
    </p:declare-step>
    
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="merge-strong" type="d2j:merge-strong"
        xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" exclude-inline-prefixes="c">
        <p:serialization port="result" method="xml" indent="true"></p:serialization>
        <p:input port="source"/>
        <p:output port="result"/>
        
        <p:wrap match="text()[not(parent::strong)][matches(. ,'^[&#xa; .,:;-]*$')]" wrapper="fmt"/>
        <p:wrap match="text()[not(parent::*[matches(name(.) , '^(strong)|(fmt)$')])]" wrapper="txt"></p:wrap>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                        <xsl:template match="node()|@*">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="*[count(child::strong) &gt; 1]">
                            <xsl:copy>
                                <xsl:copy-of select="@*"/>
                                <xsl:for-each-group select="*" group-adjacent="boolean(self::strong or (self::fmt/preceding-sibling::*[1]/name()='strong' and self::fmt/following-sibling::*[1]/name()='strong'))">
                                    <xsl:choose>
                                        <xsl:when test="current-grouping-key()">
                                            <strong>
                                                <xsl:for-each select="current-group()">
                                                    <xsl:copy-of select="@*"/>
                                                    <xsl:apply-templates select="*|text()"/>
                                                </xsl:for-each>
                                            </strong>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="current-group()">
                                                <xsl:apply-templates select="."/>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each-group>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="txt|fmt"><xsl:apply-templates/></xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity/>
    </p:declare-step>
    
    
    <p:declare-step xmlns:p="http://www.w3.org/ns/xproc" name="group-h2-sections" type="d2j:group-h2-sections"
        xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" exclude-inline-prefixes="c">
        <p:serialization port="result" method="xml" indent="true"></p:serialization>
        <p:input port="source"/>
        <p:output port="result"/>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        xmlns:d2j="http://eirikhanssen.no/doc2jats"
                        exclude-result-prefixes="xs f w pkg wp d2j">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="h2">
                            <xsl:copy>
                                <xsl:attribute name="group-start" select="count(preceding-sibling::h2)+1"></xsl:attribute>
                                <xsl:apply-templates/>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="*[preceding-sibling::h2][not(self::h2)]">
                            <xsl:copy>
                                <xsl:attribute name="group-member" select="count(preceding-sibling::h2)"></xsl:attribute>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:template>

                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        xmlns:d2j="http://eirikhanssen.no/doc2jats"
                        exclude-result-prefixes="xs f w pkg wp d2j">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="*[@group-start]">
                            <xsl:variable name="group" select="@group-start"/>
                            <section>
                                <xsl:copy>
                                    <xsl:apply-templates select="@*|node()"/>
                                </xsl:copy>
                                <xsl:apply-templates mode="grouping" select="following-sibling::*[@group-member=$group]"/>
                            </section>
                        </xsl:template>
                        
                        <xsl:template match="*[@group-member]"/>
                        
                        <xsl:template match="*[@group-member]" mode="grouping">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:delete match="@group-start"/>
        <p:delete match="@group-member"/>
        
        <p:identity/>
    </p:declare-step>

    <p:declare-step type="d2j:add-classes-to-sections" name="add-classes-to-sections">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
       
        <p:add-attribute match="section[p[matches(@class,'ref')]]" attribute-name="class" attribute-value="references"/>
        <p:add-attribute match="section[h2[matches(.,'Ackno')]]" attribute-name="class" attribute-value="acknowledgements"/>
        <p:add-attribute match="section[p[matches(@class,'abstract')]]" attribute-name="class" attribute-value="abstract"/>
        
        <p:delete match="section[@class='references']/p/@class[matches(.,'^ref$')]"></p:delete>
        <p:delete match="section[@class='abstract']/p/@class[matches(.,'^abstract')]"></p:delete>

        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:group-main-and-asides" name="group-main-and-asides" exclude-inline-prefixes="d2j pkg w wp">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:wrap match="section" group-adjacent="boolean(self::section)" wrapper="main"/>

        <p:add-attribute match="main" attribute-name="id" attribute-value="main"/>

        <p:wrap match="dl[@class='author']" group-adjacent="boolean(self::dl[@class='author'])" wrapper="aside"></p:wrap>
        
        <p:add-attribute match="aside[dl/@class='author']" attribute-name="class" attribute-value="authors"/>       

        <!-- The copyright content is hardcoded here, but really, it should depend on a parameter identifying the journal -->
        <p:insert match="main" position="before">
            <p:input port="insertion">
                <p:inline><aside class="copyright">
    <details><summary>©2018 (author name/s), CC-BY-4.0</summary>This is an Open Access article distributed under the terms of the Creative Commons Attribution 4.0 International License (<a href="http://creativecommons.org/licenses/by/4.0/">CC-BY-4.0</a>), allowing third parties to copy and redistribute the material in any medium or format and to remix, transform, and build upon the material for any purpose, even commercially, provided the original work is properly cited and states its license. </details>
</aside></p:inline>
            </p:input>
        </p:insert>
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:add-comments" name="add-comments">
        
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        xmlns:d2j="http://eirikhanssen.no/doc2jats"
                        exclude-result-prefixes="xs f w pkg wp d2j">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="section">
                            <xsl:copy>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                            <xsl:comment><xsl:text>"</xsl:text><xsl:value-of select="h2[1]/text()"/><xsl:text>" END</xsl:text></xsl:comment>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:header-and-skiplinks" name="header-and-skiplinks" 
        xmlns:d2j="http://eirikhanssen.no/doc2jats"
        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
        exclude-inline-prefixes="d2j pkg w wp">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:insert match="body" position="first-child">
            <p:input port="insertion">
                <p:inline><nav><a class="skiplink" href="#main">Skip to Abstract</a></nav></p:inline>
            </p:input>
        </p:insert>
        
        <!-- TODO: here 'Seminar' is hard-coded. but ideally the name of the journal should come from a parameter -->
        <p:insert match="body" position="first-child">
            <p:input port="insertion">
                <p:inline><header class="seminar"> </header></p:inline>
            </p:input>
        </p:insert>  
        
        <p:identity name="final"/>

    </p:declare-step>

    <p:declare-step type="d2j:delete-empty-elements" name="delete-empty-elements" 
        xmlns:d2j="http://eirikhanssen.no/doc2jats"
        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
        exclude-inline-prefixes="d2j pkg w wp">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:delete match="p[not(descendant::text())]"/>

        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="xs">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <!-- replace empty formatting with a space -->
                        <xsl:template match="(em|strong|sub|sup)[not(descendant::text())]"><xsl:text> </xsl:text></xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>

        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:generate-ids-in-references" name="generate-ids-in-references" 
        xmlns:d2j="http://eirikhanssen.no/doc2jats"
        exclude-inline-prefixes="d2j">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        exclude-result-prefixes="xs f">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:template match="section[@class='references']/p">
                            <xsl:copy>
                                <xsl:attribute name="class" select="'ref'"></xsl:attribute>
                                <!-- Debug line under disabled -->
                                <!-- <xsl:attribute name="idStringBase" select="f:getStringForIDCreation(.)"></xsl:attribute> -->
                                <xsl:attribute name="id" select="f:generateIDFromString(f:getStringForIDCreation(.))"></xsl:attribute>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity name="final"/>
        
    </p:declare-step>

    <p:declare-step type="d2j:generate-ids-in-headings" name="generate-ids-in-headings" 
        xmlns:d2j="http://eirikhanssen.no/doc2jats"
        exclude-inline-prefixes="d2j">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>
        
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        exclude-result-prefixes="xs f">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:template match="h1|h2|h3|h4|h5|h6">
                            <xsl:variable name="seq" select="string(1 + count(preceding::*[name(.)=('h1','h2','h3','h4','h5','h6')]))"/>
                            <xsl:copy>
                                <xsl:attribute name="id" select="f:generateHeadingIdFromElementContents(., $seq)"></xsl:attribute>
                                <xsl:apply-templates select="@*|node()"/>
                            </xsl:copy>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity name="final"/>
        
    </p:declare-step>
    
    <p:declare-step type="d2j:link-citations-to-references" name="link-citations-to-references" 
        xmlns:d2j="http://eirikhanssen.no/doc2jats"
        exclude-inline-prefixes="d2j">
        <p:output port="result" sequence="true"/>
        <p:serialization port="result" indent="true" method="xml" omit-xml-declaration="true"/>
        <p:input port="source"/>
        <p:input port="parameters" kind="parameter" sequence="true"/>

        <!-- cite_inside_multiple: Locate one citation where authors and multiple year are inside parens.  -->
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        exclude-result-prefixes="xs f pkg w wp">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="p[not(@ref)]/text()">
                            <xsl:analyze-string select="." regex="\([^\)]+?\)">
                                <xsl:matching-substring>                  
                                    <xsl:analyze-string select="." regex="((\p{{Lu}}\p{{Ll}}+((-)|(\s))?)*\p{{Lu}}\p{{Ll}}+((\s)|(,)|(and)|(&amp;)|(et al\.)|(and colleagues’?))+)+(\s?(\d{{4}}[a-z]?)\s?)((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?;(\s?(\d{{4}}[a-z]?)\s?;?\s?((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?)+">
                                        <!--parens begin-->
                                        <xsl:matching-substring>
                                            <cite_inside_multiple><xsl:value-of select="."/></cite_inside_multiple>
                                        </xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <xsl:value-of select="."/>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                    <!--parens end-->
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
       
        <!-- cite_inside: Locate one citation where authors and year are inside parens. -->
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        exclude-result-prefixes="xs f pkg w wp">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="p[not(@ref)]/text()">
                            <xsl:analyze-string select="." regex="\([^\)]+?\)">
                                <xsl:matching-substring>                  
                                    <xsl:analyze-string select="." regex="((\p{{Lu}}\p{{Ll}}+((-)|(\s))?)*\p{{Lu}}\p{{Ll}}+(\s|,|(and)|(&amp;)|(et al\.)|(and colleagues’?))*)+\s?((\d{{4}}[a-z]?)((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?)">
                                        <!--parens begin-->
                                        <xsl:matching-substring>
                                            <xsl:analyze-string select="." regex=";">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="."/>
                                                </xsl:matching-substring>
                                                <xsl:non-matching-substring>
                                                    <cite_inside><xsl:value-of select="."/></cite_inside>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <xsl:value-of select="."/>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                    <!--parens end-->
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <!-- cite_outside_multiple: Locate citation where authors are outside parens and multiple year inside. -->
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        exclude-result-prefixes="xs f pkg w wp">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="p[not(@ref)]/text()">
                            <xsl:analyze-string select="." regex="((\p{{Lu}}\p{{Ll}}+((-)|(\s))?)*\p{{Lu}}\p{{Ll}}+(\s|,|(and)|(&amp;)|(et al\.)|(and colleagues’?))*)+\s?\((\s?\d{{4}}[a-z]?\s?((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?);(\s?\d{{4}}[a-z]?\s?;?((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?)+\)">
                                <xsl:matching-substring>
                                    <xsl:analyze-string select="." regex="^(\p{{Lu}}\p{{Ll}}+, and )|(As )">
                                        <xsl:matching-substring><xsl:value-of select="."/></xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <cite_outside_multiple><xsl:value-of select="."/></cite_outside_multiple>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <!-- cite_outside: Locate citation where authors are outside parens.  -->
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        exclude-result-prefixes="xs f pkg w wp">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        
                        <xsl:template match="p[not(@ref)]/text()">
                            <xsl:analyze-string select="." regex="((\p{{Lu}}\p{{Ll}}+((-)|(\s))?)*\p{{Lu}}\p{{Ll}}+(\s|,|(and)|(&amp;)|(et al\.)|(and colleagues’?))*)+\s?\(((\d{{4}}[a-z]?)((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?)(;?/s?(\d{{4}}[a-z]?)((\s?,?\s?)(p\.\s?\d+)|(pp\.\s?\d+((-)|(–))\s?\d+))?)*\)">
                                <xsl:matching-substring>
                                    <xsl:analyze-string select="." regex="^(\p{{Lu}}\p{{Ll}}+, and )|(As )">
                                        <xsl:matching-substring><xsl:value-of select="."/></xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <cite_outside><xsl:value-of select="."/></cite_outside>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        

        
        <p:add-attribute match="cite_outside_multiple|cite_inside_multiple" attribute-name="data-multiple" attribute-value="multiple"/>
        <p:add-attribute match="cite_outside_multiple|cite_outside" attribute-name="data-outside" attribute-value="outside"/>
        <p:add-attribute match="cite_inside_multiple|cite_inside" attribute-name="data-inside" attribute-value="inside"/>
        <p:rename match="cite_outside|cite_inside|cite_outside_multiple|cite_inside_multiple" new-name="cite"></p:rename>
        
        <p:add-attribute match="cite[matches(text(),'(et al\.)|(and colleagues)')]" attribute-name="data-et-al" attribute-value="et-al"></p:add-attribute>
        
        <!-- Link citations to reference list -->
        <p:xslt version="2.0">
            <p:input port="source"/>
            <p:input port="parameters"><p:empty/></p:input>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:f="https://eirikhanssen.com/ns/doc2jats-functions"
                        xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage"
                        xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
                        xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
                        exclude-result-prefixes="xs f pkg w wp">
                        <xsl:import href="doc2jats-functions.xsl"/>
                        <xsl:strip-space elements="cite"/>
                        
                        <!-- generate the simplest url -->
                        <xsl:template match="cite[@data-inside][not(@data-multiple)][not(@data-et-al)]">
                            <xsl:variable name="url" select="f:generateIDFromString(f:getStringForIDCreation(.))"/>
                            <cite><a href="{concat('#',$url)}"><xsl:apply-templates/></a></cite>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        
        <p:identity name="final"/>
        
    </p:declare-step>

</p:library>

