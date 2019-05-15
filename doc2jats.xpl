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
    
    <p:output port="result" sequence="true">
        <p:pipe port="result" step="store-ocf"></p:pipe>
        <p:pipe port="result" step="store-final"></p:pipe>
        <p:pipe port="result" step="end"></p:pipe>
    </p:output>
    <p:import href="doc2jats-library.xpl"/>
    
    <d2j:docx-root/>
    
    <d2j:env/>
    
    <d2j:docx-flatten name="flat-ocf"/>

    <d2j:delete-needless-markup/>
    
    <d2j:formatting/>

    <d2j:flat-docx-to-html/>
    
    <d2j:merge-em/>
    
    <d2j:merge-strong/>
    
    <d2j:translate-ocftable-to-initial-htmltable/> 
    
    <d2j:restructure-tables/> 

    <d2j:group-lists/> 
    
    <d2j:replace-symbols/>
    
    <d2j:restructure-figures/>
  
    <d2j:filter-w-document/> 

    <d2j:author-group/>

    <d2j:cleanup/>
    
    <d2j:group-h2-sections/> 
    
    <d2j:html-head/>
   
    <p:identity name="final"/>
    
    <p:store name="store-ocf" href="flat-ocf.xml" method="xml" encoding="UTF-8" indent="true" omit-xml-declaration="true">
        <p:input port="source">
            <p:pipe port="result" step="flat-ocf"></p:pipe>
        </p:input>
    </p:store>
    
    <p:store name="store-final" href="final.xml" method="xml" encoding="UTF-8" indent="true" omit-xml-declaration="true">
        <p:input port="source">
            <p:pipe port="result" step="final"></p:pipe>
        </p:input>
    </p:store>
    
    <p:identity name="end">
        <p:input port="source">
            <p:pipe port="result" step="final"></p:pipe>
        </p:input>
    </p:identity>
    
</p:declare-step>
