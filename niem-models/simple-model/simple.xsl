<?xml version="1.0" encoding="UTF-8"?>
<stylesheet 
  exclude-result-prefixes="xsl c f mm structures xsl"
  version="2.0"
  xmlns:c="urn:oasis:names:tc:entity:xmlns:xml:catalog"
  xmlns:f="http://example.org/functions"
  xmlns:mm="http://reference.niem.gov/specification/metamodel/5.0alpha1"
  xmlns:structures="http://release.niem.gov/niem/structures/4.0/"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/XSL/Transform">

  <import href="functions.xsl"/>

  <template match="mm:Class/mm:Name">
    <message>name=&quot;<value-of select="."/>&quot;
      ap=&quot;<value-of select="f:class-get-augmentation-point-qname(..)"/></message>
    <apply-templates select="*"/>
  </template>

  <template match="*">
    <apply-templates select="*"/>
  </template>

</stylesheet>
