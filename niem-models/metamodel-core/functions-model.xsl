<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  version="2.0"
  xmlns:f-xml="http://niem.github.io/NIEM-Metamodel/xsl-functions/xml"
  xmlns:f-niem="http://niem.github.io/NIEM-Metamodel/xsl-functions/niem"
  xmlns:f-model="http://niem.github.io/NIEM-Metamodel/xsl-functions/model"
  xmlns:mm="http://reference.niem.gov/specification/metamodel/5.0alpha1"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <!-- describe a thing -->
  <function name="f-model:describe" as="xs:string">
    <param name="item" as="item()"/>
    <value-of>
      <for-each select="$item">
        <choose>
          <when test="self::element()">
            <text>element </text>
            <value-of select="node-name(.)"/>
            <for-each select="mm:Name">
              <value-of> name <value-of select="."/></value-of>
            </for-each>
            <variable name="uri" as="xs:anyURI?" select="f-niem:get-uri($item)"/>
            <if test="exists($uri)"> uri <value-of select="$uri"/></if>
            <if test="not(f-niem:is-target(.))">
              <text>&#10;  resolves to: </text>
              <value-of select="f-model:describe(f-niem:resolve(.))"/>
            </if>
          </when>
          <when test="self::text()">
            <value-of>text &quot;<value-of select="."/>&quot;</value-of>
          </when>
        </choose>
      </for-each>
    </value-of>
  </function>

  <function name="f-model:is-component" as="xs:boolean">
    <param name="element" as="element()"/>
    <for-each select="$element">
      <sequence select="self::mm:ObjectProperty
                        or self::mm:Class
                        or self::mm:DataProperty
                        or self::mm:Datatype"/>
    </for-each>
  </function>

  <function name="f-model:component-get-qname" as="xs:QName*">
    <param name="components" as="element()*"/>
    <for-each select="$components">
      <if test="not(f-model:is-component(.))">
        <message terminate="yes">f-model:component-get-qname() called on non-component (<value-of select="f-model:describe(.)"/>).</message>
      </if>
      <for-each select="f-niem:resolve(.)">
        <variable name="namespace" select="f-niem:resolve(mm:Namespace)"/>
        <sequence select="QName($namespace/mm:NamespaceURI, concat($namespace/mm:NamespacePrefixName, ':', mm:Name))"/>
      </for-each>
    </for-each>
  </function>

  <function name="f-model:component-get-namespace" as="element(mm:Namespace)*">
    <param name="components" as="element()*"/>
    <for-each select="$components">
      <for-each select="f-niem:resolve(.)">
        <if test="not(f-model:is-component(.))">
          <message terminate="yes"
                   >in f-model:component-get-namespace, member of $components is not a component (was <value-of select="f-xml:qname-get-clark-name(node-name(.))"/>).</message>
        </if>
        <sequence select="f-niem:resolve(mm:Namespace)"/>
      </for-each>
    </for-each>
  </function>

  <function name="f-model:collect-components-in-namespace" as="element()*">
    <param name="namespace" as="element()"/>
    <for-each select="f-niem:resolve($namespace)">
      <sequence select="root(.)//*[f-niem:is-target(.) and f-model:is-component(.) 
                        and f-model:component-get-namespace(.) eq current()]"/>
    </for-each>
  </function>

  <function name="f-model:component-get-referenced-components" as="element()*">
    <param name="components" as="element()*"/>
    <for-each select="$components">
      <for-each select="f-niem:resolve(.)">
        <choose>
          <when test="self::mm:ObjectProperty">
            <for-each select="f-niem:resolve(mm:SubPropertyOf)">
              <sequence select="f-niem:resolve(mm:ObjectProperty)"/>
            </for-each>
            <sequence select="f-niem:resolve(mm:Class)"/>
          </when>
          <when test="self::mm:Class">
            <for-each select="mm:ExtensionOf">
              <sequence select="f-niem:resolve(mm:Class)"/>
            </for-each>
            <for-each select="mm:HasValue">
              <sequence select="f-niem:resolve(mm:Datatype)"/>
            </for-each>
            <for-each select="mm:HasDataProperty">
              <sequence select="f-niem:resolve(mm:DataProperty)"/>
            </for-each>
            <for-each select="mm:HasObjectProperty">
              <sequence select="f-niem:resolve(mm:ObjectProperty)"/>
            </for-each>
          </when>
          <when test="self::mm:DataProperty">
            <sequence select="f-niem:resolve(mm:Datatype)"/>
          </when>
          <when test="self::mm:Datatype">
            <for-each select="mm:RestrictionOf">
              <sequence select="f-niem:resolve(mm:DataType)"/>
            </for-each>
            <for-each select="mm:ListOf">
              <sequence select="f-niem:resolve(mm:DataType)"/>
            </for-each>
            <for-each select="mm:UnionOf">
              <for-each select="mm:DataType">
                <sequence select="f-niem:resolve(.)"/>
              </for-each>
            </for-each>
          </when>
        </choose>
      </for-each>
    </for-each>
  </function>

  <!-- yield either 'HasValue, or 'HasObjectProperty', or 'none', or a message for a fail.  -->
  <function name="f-model:class-get-content-style" as="xs:string?">
    <param name="context" as="element(mm:Class)"/>
    <for-each select="f-niem:resolve($context)">
      <choose>
        <when test="f-model:component-get-qname(.) = xs:QName('structures:ObjectType')">
          <value-of>none</value-of>
        </when>
        <when test="empty(mm:DefinitionText) and mm:ContentStyleCode">
          <value-of select="mm:ContentStyleStyle"/>
        </when>
        <when test="mm:ExtensionOf">
          <variable name="base-style"
                    select="f-model:class-get-content-style(mm:ExtensionOf/mm:Class)"/>
          <choose>
            <when test="$base-style = 'none' and mm:ExtensionOf/mm:HasValue">HasValue</when>
            <when test="$base-style = 'none'">HasObjectProperty</when>
            <otherwise>
              <value-of select="$base-style"/>
            </otherwise>
          </choose>
        </when>
        <otherwise>
          <text>weird case</text>
        </otherwise>
      </choose>
    </for-each>
  </function>

  <function name="f-model:class-get-augmentation-point-qname" as="xs:QName">
    <param name="class" as="element(mm:Class)"/>
    <for-each select="f-niem:resolve($class)">
      <variable name="class-qname" select="f-model:component-get-qname(.)"/>
      <variable name="class-local-name" select="local-name-from-QName($class-qname)"/>
      <choose>
        <when test="ends-with($class-local-name, 'Type')">
          <variable name="new-local-name"
                    select="concat(
                            substring($class-local-name, 1, string-length($class-local-name) - 4),
                            'AugmentationPoint')"/>
          <sequence select="QName(namespace-uri-from-QName($class-qname),
                            concat(prefix-from-QName($class-qname), 
                            ':', 
                            $new-local-name))"/>
        </when>
        <otherwise>
          <sequence select="QName(namespace-uri-from-QName($class-qname),
                            concat(prefix-from-QName($class-qname), 
                                   ':', 
                                   prefix-from-QName($class-qname),
                                   'AugmentationPoint'))"/>
        </otherwise>
      </choose>
    </for-each>
  </function>

</stylesheet>

<!--

  <function name="f:collect-objects" as="element()*">
    <param name="context" as="element()"/>
    <variable name="context-uri" as="xs:anyURI?" select="f:get-uri($context)"/>
    <choose>
      <when test="exists($context-uri)">
        <sequence select="root($context)//*[f:get-uri(.) = $context-uri]"/>
      </when>
      <otherwise>
        <sequence select="$context"/>
      </otherwise>
    </choose>
  </function>

  <function name="f:is-first" as="xs:boolean">
    <param name="context" as="element()"/>
    <sequence select="$context eq f:collect-objects($context)[1]"/>
  </function>

  <function name="f:collect-properties" as="node()*">
    <param name="objects" as="element()*"/>
    <for-each select="$objects">
      <sequence select="@*|*|text()[string-length(normalize-space(.)) gt 0]"/>
    </for-each>
  </function>

  <function name="f:collect-parents" as="node()*">
    <param name="objects" as="element()*"/>
    <for-each select="$objects">
      <sequence select="./parent::element()"/>
    </for-each>
  </function>
-->


  

  <!--

  <function name="f:namespace-get-qname" as="xs:QName*">
    <param name="namespace" as="element(mm:Namespace)"/>
    <param name="local-name" as="xs:string"/>
    <for-each select="f-niem:resolve($namespace)">
      <sequence select="QName($namespace/mm:NamespaceURI, 
                        concat($namespace/mm:NamespacePrefixName, ':', $local-name))"/>
    </for-each>
  </function>
-->
