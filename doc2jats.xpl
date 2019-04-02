<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0"
    xmlns:d2j="http://eirikhanssen.no/doc2jats">
    
    <p:serialization port="result" indent="true" method="xml"></p:serialization>
    
    <p:input port="source">
        <p:inline><root/></p:inline>
    </p:input>
    
    <p:input port="parameters" kind="parameter"/>
    
    <p:output port="result"/>
    <p:import href="doc2jats-library.xpl"/>
    
    <d2j:docx-root/>
    
    <d2j:env/>
    
    <d2j:docx-flatten/>
    
    <d2j:flat-docx-to-html/>
    
</p:declare-step>