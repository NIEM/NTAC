<?xml version="1.0" encoding="UTF-8"?>
<!-- really important that this runs only on a fully-restacked data expression -->
<stylesheet 
  exclude-result-prefixes="xsl c f mm xsl"
  version="2.0"
  xmlns:c="urn:oasis:names:tc:entity:xmlns:xml:catalog"
  xmlns:f="http://example.org/functions"
  xmlns:mm="http://reference.niem.gov/specification/metamodel/5.0alpha1"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <import href="functions.xsl"/>

  <output method="xml" indent="yes"/>

  <function name="f:component-get-name" as="xs:string">
    <param name="context" as="element()"/>
    <choose>
      <when test="$context/@mm:name">
        <value-of select="$context/@mm:name"/>
      </when>
      <when test="$context/@structures:id">
        <value-of select="$context/@structures:id"/>
      </when>
      <when test="$context/@structures:ref">
        <value-of select="$context/@structures:ref"/>
      </when>
      <when test="$context/@structures:uri[contains(., '#')]">
        <value-of select="substring-after($context/@structures:uri, '#')"/>
      </when>
      <when test="$context/self::mm:Class and $context/parent::mm:ObjectProperty">
        <value-of>
          <value-of select="f:component-get-name($context/parent::mm:ObjectProperty)"/>
          <text>Type</text>
        </value-of>
      </when>
      <otherwise>
        <message terminate="yes">I can&apos;t figure out a name</message>
      </otherwise>
    </choose>
  </function>

  <function name="f:component-get-definition" as="xs:string">
    <param name="context" as="element()"/>
    <choose>
      <when test="$context/mm:DefinitionText">
        <value-of select="$context/mm:DefinitionText"/>
      </when>
      <when test="$context/self::mm:Class
                  and $context/parent::mm:ObjectProperty">
        <value-of>
          <text>A data type for </text>
          <value-of select="f:component-get-definition($context/parent::mm:ObjectProperty)"/>
        </value-of>
      </when>
      <otherwise>
        <value-of>A <value-of select="f:component-get-name($context)"/></value-of>
      </otherwise>
    </choose>
  </function>

  <function name="f:has-property-get-sequence-id" as="xs:integer">
    <param name="context" as="element(mm:HasProperty)"/>
    <choose>
      <when test="exists($context/@mm:sequenceID)">
        <sequence select="xs:integer($context/@mm:sequenceID)"/>
      </when>
      <when test="$context/preceding-sibling::mm:HasProperty[mm:ObjectProperty]">
        <sequence select="1 + f:has-property-get-sequence-id(
                          $context/preceding-sibling::mm:HasProperty[mm:ObjectProperty][1])"/>
      </when>
      <otherwise>
        <sequence select="1"/>
      </otherwise>
    </choose>
  </function>

  <template match="mm:Class">
    <variable name="objects" select="f:collect-objects(.)"/>
    <copy>
      <apply-templates select="@*"/>
      <if test=". eq $objects[1]">
        <if test="empty(@mm:name)">
          <attribute name="mm:name" select="f:component-get-name(.)"/>
        </if>
      </if>
      <apply-templates select="*"/>
      <if test=". eq $objects[1]">
        <if test="empty(mm:DefinitionText)">
          <element name="DefinitionText"
                   namespace="http://reference.niem.gov/specification/metamodel/5.0alpha1">
            <value-of select="f:component-get-definition(.)"/>
          </element>
        </if>
      </if>
    </copy>
  </template>

  <template match="mm:ObjectProperty">
    <variable name="objects" select="f:collect-objects(.)"/>
    <copy>
      <apply-templates select="@*"/>
      <if test=". eq $objects[1]">
        <if test="empty(@mm:name)">
          <attribute name="mm:name" select="f:component-get-name(.)"/>
        </if>
      </if>
      <apply-templates select="*"/>
    </copy>
  </template>

  <template match="mm:HasProperty">
    <variable name="objects" select="f:collect-objects(.)"/>
    <copy>
      <apply-templates select="@*"/>
      <if test=". eq $objects[1]">
        <if test="empty(@mm:minOccurs)">
          <attribute name="mm:minOccurs">0</attribute>
        </if>
        <if test="empty(@mm:maxOccurs)">
          <choose>
            <when test="mm:ObjectProperty">
              <attribute name="mm:maxOccurs">unbounded</attribute>
            </when>
            <when test="mm:DataProperty">
              <attribute name="mm:maxOccurs">1</attribute>
            </when>
            <otherwise>
              <message terminate="yes">can&apos;t figure out maxOccurs</message>
            </otherwise>
          </choose>
        </if>
        <if test="empty(@mm:sequenceID)">
          <attribute name="mm:sequenceID" select="f:has-property-get-sequence-id(.)"/>
        </if>
      </if>
      <apply-templates select="*"/>
    </copy>
  </template>

  <template match="@*|node()" priority="-1">
    <copy>
      <apply-templates select="@*|node()"/>
    </copy>
  </template>

</stylesheet>
