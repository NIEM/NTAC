<?xml version="1.0" encoding="US-ASCII" standalone="yes"?>
<schema
   queryBinding="xslt2"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://purl.oclc.org/dsdl/schematron">

  <xsl:include href="functions.xsl"/>
  
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <ns prefix="mm" uri="http://reference.niem.gov/specification/metamodel/5.0alpha1"/>
  <ns prefix="f" uri="http://example.org/functions"/>
  <ns prefix="structures" uri="http://release.niem.gov/niem/structures/4.0/"/>
  
  <pattern>
    <rule context="/*">
      <assert test="self::mm:Model">Document element must be mm:Model.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[@structures:uri]">
      <assert test="false()">@structures:uri is prohibited.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[@structures:metadata]">
      <assert test="false()">@structures:metadata is prohibited.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[@structures:relationshipMetadata]">
      <assert test="false()">@structures:relationshipMetadata is prohibited.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[some $attribute in @* satisfies namespace-uri($attribute) = ('urn:us:gov:ic:ism','urn:us:gov:ic:ntk')]">
      <assert test="false()">Attributes from the ISM and NTK namespaces are prohibited.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*">
      <assert test="count(@structures:id | @structures:ref) = (0,1)">
        An element must have at most one of @structures:id or @structures:ref.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[xs:boolean(@xsi:nil) = true()]">
      <assert test="exists(@structures:ref)">An element with xsi:nil=true must have @structures:ref.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[@structures:ref]">
      <assert test="exists(f:resolve(.))"
              >@structures:ref must resolve to an ID within the document.</assert>
      <assert test="node-name(f:resolve(.)) = node-name(.)"
              >element must resolve to target element with same name as source element.</assert>
      <assert test="self::mm:Namespace 
                    or self::mm:ObjectProperty 
                    or self::mm:Class 
                    or self::mm:DataProperty
                    or self::mm:Datatype"
              >This element is not allowed to have @structures:ref (element is <value-of select="node-name(.)"/>.</assert>
      <assert test="xs:boolean(@xsi:nil)=true()"
              >An element with @structures:ref must have xsi:nil=true.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[f:is-target(.)
                     and (self::mm:ObjectProperty or self::mm:Class or self::mm:DataProperty or self::mm:Datatype)]">
      <let name="component-qname" value="f:component-get-qname(.)"/>
      <let name="matches" value="root(.)//*[f:is-component(.) and f:is-target(.)
                                            and f:component-get-qname(.) = $component-qname]"/>
      <assert test="1 = count($matches)"
              >There can be only one component with a given QName (QName is <value-of select="f:qname-get-clark-name($component-qname)"/>).</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:DefinitionText">
      <assert test="string-length(normalize-space(.)) gt 0"
              >mm:DefinitionText must not be empty.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[f:is-component(.) and f:is-target(.) and mm:DefinitionText]">
      <assert test="f:resolve(mm:Namespace)/mm:DefinitionText"
              >An object property that is a definition must have a namespace that is a definition.</assert>
    </rule>
    <rule context="*[f:is-component(.) and f:is-target(.) and empty(mm:DefinitionText)]">
      <assert test="empty(f:resolve(mm:Namespace)/mm:DefinitionText)"
              >An object property that is a reference must have a namespace that is a reference.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:ObjectProperty[f:is-target(.) and mm:DefinitionText]">
      <assert test="true()">OK</assert>
    </rule>
    <rule context="mm:ObjectProperty[f:is-target(.) and empty(mm:DefinitionText)]">
      <assert test="empty(mm:SubPropertyOf)"
              >An ObjectProperty that is a reference must not have mm:SubPropertyOf.</assert>
      <assert test="empty(mm:Class)"
              >An ObjectProperty that is a reference must not have mm:Class.</assert>
      <assert test="empty(mm:AbstractIndicator)"
              >An ObjectProperty that is a reference must not have mm:AbstractIndicator.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:ObjectProperty[f:is-target(.) and mm:DefinitionText and empty(mm:Class)]">
      <assert test="xs:boolean(mm:AbstractIndicator) = true()"
              >An object property with no class must be abstract.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:Class[f:is-target(.) and f:component-get-qname(.) = xs:QName('structures:ObjectType')]">
      <assert test="empty(mm:DefinitionText)"
              >A Class for structures:ObjectType must not have mm:DefinitionText.</assert>
      <assert test="empty(mm:AbstractIndicator)"
              >A Class for structures:ObjectType must not have mm:AbstractIndicator.</assert>
      <assert test="empty(mm:ExtensionOf)"
              >A Class for structures:ObjectType must not have mm:ExtensionOf.</assert>
      <assert test="empty(mm:ContentStyleCode)"
              >A Class for structures:ObjectType must not have mm:ContentStyleCode.</assert>
    </rule>
    <rule context="mm:Class[f:is-target(.) and mm:DefinitionText]">
      <assert test="mm:ExtensionOf"
              >A class that is a definition must have mm:ExtensionOf</assert>
    </rule>
    <rule context="mm:Class[f:is-target(.) and empty(mm:DefinitionText)]">
      <assert test="empty(mm:AbstractIndictoar)"
              >A class that is a reference must not have mm:AbstractIndicator.</assert>
      <assert test="empty(mm:ExtensionOf)"
              >A class that is a reference must not have mm:ExtensionOf.</assert>
      <assert test="mm:ContentStyleCode"
              >A Class that is a reference must have mm:ContentStyleCode.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:ExtensionOf[mm:HasValue]">
      <assert test="empty(mm:HasObjectProperty)"
              >An extension with mm:HasValue must not have mm:HasObjectProperty.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="mm:ExtensionOf[mm:HasObjectProperty]">
      <assert test="empty(mm:HasValue)"
              >An extension with mm:HasObjectProperty must not have mm:HasValue.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:Class[f:component-get-qname(.) = xs:QName('structures:ObjectType')]">
      <assert test="true()">OK</assert>
    </rule>
    <rule context="mm:Class[mm:ExtensionOf/mm:Class and f:component-get-qname(mm:Extension/mm:Class) = 'HasValue']">
      <assert test="empty(mm:HasObjectProperty)"
              >A class that extends a class with content style HasValue must not have mm:HasObjectProperty.</assert>
    </rule>
    <rule context="mm:Class[mm:ExtensionOf/mm:Class and f:component-get-qname(mm:Extension/mm:Class) = 'HasObjectProperty']">
      <assert test="empty(mm:HasValue)"
              >A class that extends a class with content style HasObjectProperty must not have mm:HasValue.</assert>
    </rule>
    <rule context="mm:Class[mm:ExtensionOf/mm:Class]">
      <assert test="true()"
              >Strange result from f:component-get-qname(): &quot;<value-of select="f:component-get-qname(mm:Extension/mm:Class)"/>&quot;.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:DataProperty[f:is-target(.) and mm:DefinitionText]">
      <assert test="mm:Datatype"
              >A DataProperty that is a definition must have mm:Datatype.</assert>
    </rule>
    <rule context="mm:DataProperty[f:is-target(.) and empty(mm:DefinitionText)]">
      <assert test="empty(mm:Datatype)"
              >A DataProperty that is a reference must not have mm:Datatype.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="mm:Datatype[f:is-target(.) and mm:DefinitionText]">
      <assert test="1 = count(mm:ListOf|mm:UnionOf|mm:RestrictionOf)"
              >A Datatype that is a definition must have one of ListOf, UnionOf, or RestrictionOf.</assert>
    </rule>
    <rule context="mm:Datatype[f:is-target(.) and empty(mm:DefinitionText)]">
      <assert test="empty(mm:Datatype)"
              >A Datatype that is a reference must not have mm:Datatype.</assert>
    </rule>
  </pattern>



</schema>
