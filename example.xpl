<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0" xmlns:example="http://example.de">
    <p:input port="parameters" kind="parameter"></p:input>
    <p:input port="source">
        <p:inline>
            <doc>Small example</doc>
        </p:inline>
    </p:input>
    <p:output port="result"/>
    <p:import href="library.xpl"/>
    <example:identity/>
</p:declare-step>