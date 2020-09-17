<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  exclude-result-prefixes="xsl c f mm xsl"
  version="2.0"
  xmlns:c="urn:oasis:names:tc:entity:xmlns:xml:catalog"
  xmlns:f="http://example.org/functions"
  xmlns:mm="http://reference.niem.gov/specification/metamodel/5.0alpha1"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <import href="functions.xsl"/>

  <output method="xml" indent="yes"/>

  <!-- generate a structures identifier if possible, and fall back to uri if needed 
       prefer either "id" or "ref". -->
  
  <variable name="prefer-id" as="element(f:prefer)"><f:prefer>id</f:prefer></variable>
  <variable name="prefer-ref" as="element(f:prefer)"><f:prefer>ref</f:prefer></variable>

  <function name="f:generate-id">
    <param name="context" as="element()"/>
    <param name="prefer" as="element(f:prefer)"/>
    <variable name="uri" as="xs:anyURI" select="f:get-uri($context)"/>
    <choose>
      <when test="contains($uri, '#')">
        <variable name="candidate-id" select="substring-after($uri, '#')"/>
        <choose>
          <when test="$uri = f:get-uri-for-id($context, $candidate-id)">
            <choose>
              <when test="$prefer eq $prefer-id">
                <attribute name="structures:id" select="$candidate-id"/>
              </when>
              <otherwise>
                <attribute name="structures:ref" select="$candidate-id"/>
              </otherwise>
            </choose>
          </when>
          <otherwise>
            <attribute name="structures:uri" select="$uri"/>
          </otherwise>
        </choose>
      </when>
      <otherwise>
        <attribute name="structures:uri" select="$uri"/>
      </otherwise>
    </choose>
  </function>

  
  <template match="*">
    <variable name="objects" select="f:collect-objects(.)"/>
    <!-- omit anything that's just a child of the model and has already been covered -->
    <if test=". eq $objects[1] or not(parent::mm:Model)">
      <copy>
        <if test=". eq root()">
          <namespace name="structures">http://release.niem.gov/niem/structures/4.0/</namespace>
          <namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</namespace>
        </if>
        <variable name="uri" as="xs:anyURI?" select="f:get-uri(.)"/>
        <!-- if we're on the first occurrence of an object -->        
        <choose>
          <when test=". eq $objects[1]">
            <if test="count($objects) gt 1">
              <sequence select="f:generate-id(., $prefer-id)"/>
            </if>
            <variable name="properties" select="f:collect-properties($objects)"/>
            <variable name="parents" select="f:collect-parents($objects)"/>
            <for-each select="$properties[
                              self::attribute()[not(node-name(.) = (xs:QName('structures:uri'), xs:QName('structures:id'), xs:QName('structures:ref'), xs:QName('xsi:nil')))]
                              or self::text()]">
              <copy-of select="."/>
            </for-each>
            <for-each select="$properties[self::element()]">
              <apply-templates select="."/>
            </for-each>
          </when>
          <otherwise>
            <sequence select="f:generate-id(., $prefer-ref)"/>
            <attribute name="xsi:nil">true</attribute>
          </otherwise>
        </choose>
      </copy>
    </if>
  </template>

  <template match="text()"/>

</stylesheet>
