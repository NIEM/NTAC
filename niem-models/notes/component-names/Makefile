
example_xml_files = ${wildcard example-*.xml}

valid_tokens = ${example_xml_files:%=token/xsd-valid/%}

default: ${valid_tokens}

token/xsd-valid/%: % token/lint/%
	xs-validate -c xml-catalog.xml $<

token/lint/%: %
	xmllint --noout $<
