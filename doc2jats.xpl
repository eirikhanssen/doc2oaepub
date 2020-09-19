<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step name="doc2jats"
    xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    version="1.0"
    xmlns:d2j="http://eirikhanssen.no/doc2jats">
    
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
    <p:import href="doc2jats-library.xpl"/>
    
    <d2j:docx-root/>
    
    <d2j:env/>
    
    <d2j:docx-flatten name="flat-ocf"/>

    <d2j:delete-needless-markup name="delete-needless-markup"/>
    
    <d2j:formatting name="formatting"/>

    <d2j:flat-docx-to-html name="flat-docx-to-html"/>
    
    <d2j:merge-em name="merge-em"/>
    
    <d2j:merge-strong name="merge-strong"/>
    
    <d2j:translate-ocftable-to-initial-htmltable name="translate-ocftable-to-initial-htmltable"/> 
    
    <d2j:restructure-tables name="restructure-tables"/> 

    <d2j:group-lists name="group-lists"/> 
    
    <d2j:replace-symbols name="replace-symbols"/>
    
    <d2j:restructure-figures name="restructure-figures"/>
  
    <d2j:filter-w-document name="filter-w-document"/> 

    <d2j:author-group name="author-group"/>
    
    <d2j:rename-elements name="rename-elements"/>

    <d2j:cleanup name="cleanup"/>

    <p:add-attribute match="html" attribute-name="data-journal">
        <p:with-option name="attribute-value" select="$journal"></p:with-option>
    </p:add-attribute>

    <d2j:group-h2-sections name="group-h2-sections"/> 

    <d2j:add-classes-to-sections name="add-classes-to-sections"/>
    
    <d2j:group-main-and-asides name="group-main-and-asides"/>
    
    <d2j:add-comments name="add-comments"/>
    
    <d2j:html-head name="html-head"/>
   
    <d2j:header-and-skiplinks name="header-and-skiplinks"/>
    
    <d2j:delete-empty-elements name="delete-empty-elements"/>
    
    <d2j:generate-ids-in-references name="generate-ids-in-references"/>
    
    <d2j:generate-ids-in-headings name="generate-ids-in-headings"/>
    
    <d2j:link-citations-to-references name="link-citations-to-references"/>
    
    <d2j:text-corrections name="text-corrections"/>
    
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

