<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="doc2jats"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0"
    xmlns:d2ep="http://eirikhanssen.no/doc2oaepub">
    
    <p:serialization port="result" indent="true" method="xml"></p:serialization>
    
    <!-- Named parameters given to the pipeline are available as options if we declare options with their names here -->
    <p:option name="output_xml"/>
    <p:option name="output_flat_ocf"/>
    <p:option name="journal"/>
    
    <p:input port="source">
        <p:inline><root/></p:inline>
    </p:input>
    
    <p:input port="parameters" kind="parameter"/>
    
    <p:output port="result" sequence="true">
<!--        <p:pipe port="result" step="store-ocf"></p:pipe>-->
<!--        <p:pipe port="result" step="store-final"></p:pipe>-->
        <p:pipe port="result" step="end"></p:pipe>
    </p:output>
    <p:import href="doc2oaepub-library.xpl"/>
    
    <d2ep:docx-root/>
    
    <d2ep:env/>
    
    <d2ep:docx-flatten name="flat-ocf"/>

    <d2ep:delete-needless-markup name="delete-needless-markup"/>
    
    <d2ep:formatting name="formatting"/>

    <d2ep:flat-docx-to-html name="flat-docx-to-html"/>
    
    <d2ep:merge-em name="merge-em"/>
    
    <d2ep:merge-strong name="merge-strong"/>
    
    <d2ep:translate-ocftable-to-initial-htmltable name="translate-ocftable-to-initial-htmltable"/> 
    
    <d2ep:restructure-tables name="restructure-tables"/> 

    <d2ep:group-lists name="group-lists"/> 
    
    <d2ep:replace-symbols name="replace-symbols"/>
    
    <d2ep:restructure-figures name="restructure-figures"/>
  
    <d2ep:filter-w-document name="filter-w-document"/> 

    <d2ep:author-group name="author-group"/>
    
    <d2ep:rename-elements name="rename-elements"/>

    <d2ep:cleanup name="cleanup"/>

    <p:add-attribute match="html" attribute-name="data-journal">
        <p:with-option name="attribute-value" select="$journal"></p:with-option>
    </p:add-attribute>

    <d2ep:group-h2-sections name="group-h2-sections"/> 

    <d2ep:add-classes-to-sections name="add-classes-to-sections"/>
    
    <d2ep:group-main-and-asides name="group-main-and-asides"/>
    
    <d2ep:add-comments name="add-comments"/>
    
    <d2ep:html-head name="html-head"/>
   
    <d2ep:header-and-skiplinks name="header-and-skiplinks"/>
    
    <d2ep:delete-empty-elements name="delete-empty-elements"/>
    
    <d2ep:generate-ids-in-references name="generate-ids-in-references"/>
    
    <d2ep:generate-ids-in-headings name="generate-ids-in-headings"/>
    
    <d2ep:link-citations-to-references name="link-citations-to-references"/>
    
    <d2ep:text-corrections name="text-corrections"/>
    
    <p:identity name="final"/>
    
    <p:store name="store-ocf" method="xml" indent="true" encoding="UTF-8" omit-xml-declaration="true">
        <!-- given as a parameter to the pipeline -->
        <p:with-option name="href" select="$output_flat_ocf"/>
        <p:input port="source">
            <p:pipe port="result" step="flat-ocf"></p:pipe>
        </p:input>
    </p:store>
    
    <p:store name="store_xml" method="xml" indent="true" encoding="UTF-8" omit-xml-declaration="true">
        <!-- given as a parameter to the pipeline -->
        <p:with-option name="href" select="$output_xml"/>
        <p:input port="source">
            <p:pipe step="final" port="result"/>
        </p:input>
    </p:store>
    
    <!--  Make copies in the pipeline folder  -->
    <p:store name="store-xml-2" method="xml" href="final.xml" encoding="UTF-8" indent="true" omit-xml-declaration="true">
        <p:input port="source">
            <p:pipe port="result" step="final"></p:pipe>
        </p:input>
    </p:store>
    
    <!--  Make copies in the pipeline folder  -->    
    <p:store name="store-ocf-2" method="xml" href="flat-ocf" encoding="UTF-8" indent="true" omit-xml-declaration="true">
        <p:input port="source">
            <p:pipe port="result" step="flat-ocf"></p:pipe>
        </p:input>
    </p:store>
    
    <!--  Make a debug copy in the pipeline folder  -->    
    <p:store name="debug" method="xml" href="debug.xml" encoding="UTF-8" indent="true" omit-xml-declaration="true">
        <p:input port="source">
            <p:pipe port="result" step="flat-docx-to-html"></p:pipe>
        </p:input>
    </p:store>
    
    <p:identity name="end">
        <p:input port="source">
            <p:pipe port="result" step="final"></p:pipe>
        </p:input>
    </p:identity>
    
</p:declare-step>

