<?xml version="1.0" encoding="US-ASCII" standalone="yes"?>
<schema
   queryBinding="xslt2"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://purl.oclc.org/dsdl/schematron">

  <xsl:include href="functions-xml.xsl"/>
  <xsl:include href="functions-niem.xsl"/>
  
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <ns prefix="f-xml" uri="http://niem.github.io/NIEM-Metamodel/xsl-functions/xml"/>
  <ns prefix="f-niem" uri="http://niem.github.io/NIEM-Metamodel/xsl-functions/niem"/>
  <ns prefix="structures" uri="http://release.niem.gov/niem/structures/4.0/"/>
  
  <pattern>
    <rule context="*">
      <assert test="count(@structures:id | @structures:ref | @structures:uri) = (0,1)">
        An element must have at most one of @structures:id, @structures:ref, or @structures:uri.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="*[@structures:ref]">
      <assert test="exists(f-niem:resolve(.))"
              >@structures:ref must resolve to an ID within the document.</assert>
    </rule>
  </pattern>

</schema>
