<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="doc2jats" 
    xmlns:p="http://www.w3.org/ns/xproc" 
    xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0">
    <p:option name="filename" required="true"/>
    <p:option name="folder" required="true"/>
    <p:option name="timestamp" required="true"/>
    <p:input port="source"><p:empty></p:empty></p:input>
    
    <!--<p:group>
        <p:variable name="filename-base" select="replace($filename, '^(.+?)[.][^.]+$', '$1')"></p:variable>
        <p:variable name="filename-ext" select="replace($filename, '^.+?[.]([^.]+)$', '$1')"></p:variable>
        <p:variable name="new-name" select="concat($filename, '-', $timestamp)"></p:variable>
        
        <p:identity/>
    </p:group>-->
    
    <p:output port="result" sequence="true"/>
    <p:import href="docx-flatten.xpl"></p:import>
    <p:identity/>
</p:declare-step>