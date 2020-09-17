<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f-xml="http://niem.github.io/NIEM-Metamodel/xsl-functions/xml"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <function name="f-xml:get-base-uri" as="xs:anyURI">
    <param name="context" as="element()"/>
    <variable name="base-attribute" as="attribute(xml:base)?"
              select="$context/ancestor-or-self::*[@xml:base][1]/@xml:base"/>
    <variable name="base-uri">
      <choose>
        <when test="exists($base-attribute)">
          <value-of select="xs:anyURI($base-attribute)"/>
        </when>
        <otherwise>
          <value-of select="base-uri($context)"/>
        </otherwise>
      </choose>
    </variable>
    <choose>
      <when test="ends-with($base-uri, '#')">
        <sequence select="xs:anyURI(substring($base-uri,1,string-length($base-uri) - 1))"/>
      </when>
      <otherwise>
        <sequence select="$base-uri"/>
      </otherwise>
    </choose>
  </function>

  <function name="f-xml:get-uri-for-id" as="xs:anyURI">
    <param name="context" as="element()"/>
    <param name="id" as="xs:string"/>
    <sequence select="resolve-uri(concat('#', $id), f-xml:get-base-uri($context))"/>
  </function>

  <function name="f-xml:qname-get-clark-name" as="xs:string">
    <param name="qname" as="xs:QName"/>
    <value-of>{<value-of select="namespace-uri-from-QName($qname)"/>}<value-of select="local-name-from-QName($qname)"/></value-of>
  </function>

</stylesheet>
