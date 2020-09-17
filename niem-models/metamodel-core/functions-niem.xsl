<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f-xml="http://niem.github.io/NIEM-Metamodel/xsl-functions/xml"
  xmlns:f-niem="http://niem.github.io/NIEM-Metamodel/xsl-functions/niem"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <function name="f-niem:get-uri" as="xs:anyURI?">
    <param name="context" as="element()"/>
    <choose>
      <when test="exists($context/@structures:id)">
        <value-of select="resolve-uri(concat('#', $context/@structures:id), f-xml:get-base-uri($context))"/>
      </when>
      <when test="exists($context/@structures:ref)">
        <value-of select="resolve-uri(concat('#', $context/@structures:ref), f-xml:get-base-uri($context))"/>
      </when>
      <when test="exists($context/@structures:uri)">
        <value-of select="resolve-uri($context/@structures:uri, f-xml:get-base-uri($context))"/>
      </when>
    </choose>
  </function>

<!--
  <function name="f:collect-objects" as="element()*">
    <param name="context" as="element()"/>
    <variable name="context-uri" as="xs:anyURI?" select="f-niem:get-uri($context)"/>
    <choose>
      <when test="exists($context-uri)">
        <sequence select="root($context)//*[f-niem:get-uri(.) = $context-uri]"/>
      </when>
      <otherwise>
        <sequence select="$context"/>
      </otherwise>
    </choose>
  </function>
-->

<!--
  <function name="f:is-first" as="xs:boolean">
    <param name="context" as="element()"/>
    <sequence select="$context eq f:collect-objects($context)[1]"/>
  </function>
-->

<!--
  <function name="f:collect-properties" as="node()*">
    <param name="objects" as="element()*"/>
    <for-each select="$objects">
      <sequence select="@*|*|text()[string-length(normalize-space(.)) gt 0]"/>
    </for-each>
  </function>
-->

<!--
  <function name="f:collect-parents" as="node()*">
    <param name="objects" as="element()*"/>
    <for-each select="$objects">
      <sequence select="./parent::element()"/>
    </for-each>
  </function>
-->

  <function name="f-niem:resolve" as="element()?">
    <param name="context" as="element()?"/>
    <choose>
      <when test="empty($context)"/>
      <when test="$context/@structures:ref">
        <sequence select="root($context)//*[@structures:id = $context/@structures:ref]"/>
      </when>
      <otherwise>
        <sequence select="$context"/>
      </otherwise>
    </choose>
  </function>

  <function name="f-niem:is-target" as="xs:boolean">
    <param name="context" as="element()"/>
    <sequence select="empty($context/@structures:ref)"/>
  </function>

</stylesheet>
