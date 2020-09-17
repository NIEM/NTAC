<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mm="http://reference.niem.gov/specification/metamodel/5.0alpha1"
                xmlns:f-xml="http://niem.github.io/NIEM-Metamodel/xsl-functions/xml"
                xmlns:f-niem="http://niem.github.io/NIEM-Metamodel/xsl-functions/niem"
                xmlns:f-model="http://niem.github.io/NIEM-Metamodel/xsl-functions/model"
                xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xs"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/XSL/Transform" prefix="xsl"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
         <svrl:ns-prefix-in-attribute-values uri="http://reference.niem.gov/specification/metamodel/5.0alpha1"
                                             prefix="mm"/>
         <svrl:ns-prefix-in-attribute-values uri="http://niem.github.io/NIEM-Metamodel/xsl-functions/xml"
                                             prefix="f-xml"/>
         <svrl:ns-prefix-in-attribute-values uri="http://niem.github.io/NIEM-Metamodel/xsl-functions/niem"
                                             prefix="f-niem"/>
         <svrl:ns-prefix-in-attribute-values uri="http://niem.github.io/NIEM-Metamodel/xsl-functions/model"
                                             prefix="f-model"/>
         <svrl:ns-prefix-in-attribute-values uri="http://release.niem.gov/niem/structures/4.0/" prefix="structures"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
      </svrl:schematron-output>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->
   <xsl:include xmlns="http://purl.oclc.org/dsdl/schematron"
                href="../common/functions-for-xml-data.xsl"/>
   <xsl:include xmlns="http://purl.oclc.org/dsdl/schematron"
                href="../common/functions-for-niem-data.xsl"/>
   <xsl:include xmlns="http://purl.oclc.org/dsdl/schematron"
                href="../common/functions-for-models.xsl"/>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="/*" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/*"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::mm:Model"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="self::mm:Model">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Document element must be mm:Model.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[@structures:uri]" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@structures:uri]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@structures:uri is prohibited.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[@structures:metadata]" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@structures:metadata]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@structures:metadata is prohibited.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[@structures:relationshipMetadata]"
                 priority="1000"
                 mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[@structures:relationshipMetadata]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@structures:relationshipMetadata is prohibited.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[some $attribute in @* satisfies namespace-uri($attribute) = ('urn:us:gov:ic:ism','urn:us:gov:ic:ntk')]"
                 priority="1000"
                 mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[some $attribute in @* satisfies namespace-uri($attribute) = ('urn:us:gov:ic:ism','urn:us:gov:ic:ntk')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Attributes from the ISM and NTK namespaces are prohibited.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[xs:boolean(@xsi:nil) = true()]" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[xs:boolean(@xsi:nil) = true()]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(@structures:ref)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(@structures:ref)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An element with xsi:nil=true must have @structures:ref.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[@structures:ref]" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[@structures:ref]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="node-name(f-niem:resolve(.)) = node-name(.)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="node-name(f-niem:resolve(.)) = node-name(.)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>element must resolve to target element with same name as source element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::mm:Namespace                      or self::mm:ObjectProperty                      or self::mm:Class                      or self::mm:DataProperty                     or self::mm:Datatype"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="self::mm:Namespace or self::mm:ObjectProperty or self::mm:Class or self::mm:DataProperty or self::mm:Datatype">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>This element is not allowed to have @structures:ref (element is <xsl:text/>
                  <xsl:value-of select="node-name(.)"/>
                  <xsl:text/>.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:boolean(@xsi:nil)=true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:boolean(@xsi:nil)=true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An element with @structures:ref must have xsi:nil=true.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[f-niem:is-target(.)                      and (self::mm:ObjectProperty or self::mm:Class or self::mm:DataProperty or self::mm:Datatype)]"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[f-niem:is-target(.)                      and (self::mm:ObjectProperty or self::mm:Class or self::mm:DataProperty or self::mm:Datatype)]"/>
      <xsl:variable name="component-qname" select="f-model:component-get-qname(.)"/>
      <xsl:variable name="matches"
                    select="root(.)//*[f-model:is-component(.) and f-niem:is-target(.)                                             and f-model:component-get-qname(.) = $component-qname]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="1 = count($matches)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="1 = count($matches)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>There can be only one component with a given QName (QName is <xsl:text/>
                  <xsl:value-of select="f-xml:qname-get-clark-name($component-qname)"/>
                  <xsl:text/>).</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:DefinitionText" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mm:DefinitionText"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(normalize-space(.)) gt 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="string-length(normalize-space(.)) gt 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>mm:DefinitionText must not be empty.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="*[f-model:is-component(.) and f-niem:is-target(.) and mm:DefinitionText]"
                 priority="1001"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[f-model:is-component(.) and f-niem:is-target(.) and mm:DefinitionText]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="f-niem:resolve(mm:Namespace)/mm:DefinitionText"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="f-niem:resolve(mm:Namespace)/mm:DefinitionText">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An object property that is a definition must have a namespace that is a definition.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="*[f-model:is-component(.) and f-niem:is-target(.) and empty(mm:DefinitionText)]"
                 priority="1000"
                 mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="*[f-model:is-component(.) and f-niem:is-target(.) and empty(mm:DefinitionText)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(f-niem:resolve(mm:Namespace)/mm:DefinitionText)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(f-niem:resolve(mm:Namespace)/mm:DefinitionText)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An object property that is a reference must have a namespace that is a reference.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:ObjectProperty[f-niem:is-target(.) and mm:DefinitionText]"
                 priority="1001"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:ObjectProperty[f-niem:is-target(.) and mm:DefinitionText]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OK</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:ObjectProperty[f-niem:is-target(.) and empty(mm:DefinitionText)]"
                 priority="1000"
                 mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:ObjectProperty[f-niem:is-target(.) and empty(mm:DefinitionText)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:SubPropertyOf)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:SubPropertyOf)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An ObjectProperty that is a reference must not have mm:SubPropertyOf.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:Class)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:Class)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An ObjectProperty that is a reference must not have mm:Class.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:AbstractIndicator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(mm:AbstractIndicator)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An ObjectProperty that is a reference must not have mm:AbstractIndicator.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:ObjectProperty[f-niem:is-target(.) and mm:DefinitionText and empty(mm:Class)]"
                 priority="1000"
                 mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:ObjectProperty[f-niem:is-target(.) and mm:DefinitionText and empty(mm:Class)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:boolean(mm:AbstractIndicator) = true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="xs:boolean(mm:AbstractIndicator) = true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An object property with no class must be abstract.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:Class[f-niem:is-target(.) and f-model:component-get-qname(.) = xs:QName('structures:ObjectType')]"
                 priority="1002"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[f-niem:is-target(.) and f-model:component-get-qname(.) = xs:QName('structures:ObjectType')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:DefinitionText)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:DefinitionText)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Class for structures:ObjectType must not have mm:DefinitionText.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:AbstractIndicator)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(mm:AbstractIndicator)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Class for structures:ObjectType must not have mm:AbstractIndicator.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:ExtensionOf)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:ExtensionOf)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Class for structures:ObjectType must not have mm:ExtensionOf.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:ContentStyleCode)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(mm:ContentStyleCode)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Class for structures:ObjectType must not have mm:ContentStyleCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:Class[f-niem:is-target(.) and mm:DefinitionText]"
                 priority="1001"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[f-niem:is-target(.) and mm:DefinitionText]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="mm:ExtensionOf"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="mm:ExtensionOf">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A class that is a definition must have mm:ExtensionOf</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:Class[f-niem:is-target(.) and empty(mm:DefinitionText)]"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[f-niem:is-target(.) and empty(mm:DefinitionText)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:AbstractIndictoar)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(mm:AbstractIndictoar)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A class that is a reference must not have mm:AbstractIndicator.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:ExtensionOf)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:ExtensionOf)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A class that is a reference must not have mm:ExtensionOf.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="mm:ContentStyleCode"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="mm:ContentStyleCode">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Class that is a reference must have mm:ContentStyleCode.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:ExtensionOf[mm:HasValue]" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:ExtensionOf[mm:HasValue]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:HasObjectProperty)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(mm:HasObjectProperty)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An extension with mm:HasValue must not have mm:HasObjectProperty.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:ExtensionOf[mm:HasObjectProperty]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:ExtensionOf[mm:HasObjectProperty]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:HasValue)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:HasValue)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An extension with mm:HasObjectProperty must not have mm:HasValue.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:Class[f-model:component-get-qname(.) = xs:QName('structures:ObjectType')]"
                 priority="1003"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[f-model:component-get-qname(.) = xs:QName('structures:ObjectType')]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>OK</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:Class[mm:ExtensionOf/mm:Class and f-model:component-get-qname(mm:Extension/mm:Class) = 'HasValue']"
                 priority="1002"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[mm:ExtensionOf/mm:Class and f-model:component-get-qname(mm:Extension/mm:Class) = 'HasValue']"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:HasObjectProperty)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="empty(mm:HasObjectProperty)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A class that extends a class with content style HasValue must not have mm:HasObjectProperty.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:Class[mm:ExtensionOf/mm:Class and f-model:component-get-qname(mm:Extension/mm:Class) = 'HasObjectProperty']"
                 priority="1001"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[mm:ExtensionOf/mm:Class and f-model:component-get-qname(mm:Extension/mm:Class) = 'HasObjectProperty']"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:HasValue)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:HasValue)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A class that extends a class with content style HasObjectProperty must not have mm:HasValue.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:Class[mm:ExtensionOf/mm:Class]"
                 priority="1000"
                 mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Class[mm:ExtensionOf/mm:Class]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Strange result from f-model:component-get-qname(): "<xsl:text/>
                  <xsl:value-of select="f-model:component-get-qname(mm:Extension/mm:Class)"/>
                  <xsl:text/>".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:DataProperty[f-niem:is-target(.) and mm:DefinitionText]"
                 priority="1001"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:DataProperty[f-niem:is-target(.) and mm:DefinitionText]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="mm:Datatype"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="mm:Datatype">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A DataProperty that is a definition must have mm:Datatype.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:DataProperty[f-niem:is-target(.) and empty(mm:DefinitionText)]"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:DataProperty[f-niem:is-target(.) and empty(mm:DefinitionText)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:Datatype)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:Datatype)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A DataProperty that is a reference must not have mm:Datatype.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>

   <!--PATTERN -->


	  <!--RULE -->
   <xsl:template match="mm:Datatype[f-niem:is-target(.) and mm:DefinitionText]"
                 priority="1001"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Datatype[f-niem:is-target(.) and mm:DefinitionText]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="1 = count(mm:ListOf|mm:UnionOf|mm:RestrictionOf)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="1 = count(mm:ListOf|mm:UnionOf|mm:RestrictionOf)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Datatype that is a definition must have one of ListOf, UnionOf, or RestrictionOf.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="mm:Datatype[f-niem:is-target(.) and empty(mm:DefinitionText)]"
                 priority="1000"
                 mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mm:Datatype[f-niem:is-target(.) and empty(mm:DefinitionText)]"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="empty(mm:Datatype)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="empty(mm:Datatype)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A Datatype that is a reference must not have mm:Datatype.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
</xsl:stylesheet>
