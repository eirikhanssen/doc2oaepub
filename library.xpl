<p:library xmlns:p="http://www.w3.org/ns/xproc" xmlns:example="http://example.de" version="1.0">
    <p:declare-step type="example:identity" name="example-identity">
        <p:input port="parameters" kind="parameter"/>
        <p:input port="source" sequence="true"/>
        <p:output port="result"/>
        <p:xslt version="2.0">
            <p:input port="parameters"/>
            <p:input port="source"/>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                        <xsl:param name="testparam" select="'some default value'"/>
                        <xsl:template match="/doc">
                            <xsl:copy>
                                <xsl:apply-templates/>
                                <param><xsl:value-of select="$testparam"/></param>
                            </xsl:copy>
                        </xsl:template>
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
        </p:xslt>
        <p:identity/>
    </p:declare-step>
</p:library>