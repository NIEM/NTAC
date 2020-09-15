# Metamodel 2020-08-25 08:28

## What problems does it solve?

- Multiple rendering targets
	- Easier support for multiple dev environments
- Eliminates needing to reverse engineer NIEM concepts from Schema
	- There's a concept => schema mapping that isn't trivially reversible
	- Makes tools easier
	- Improved understanding via the distribution
- Eliminates conversions between render targets
	- **Not for instances, though**
- Abstract terms instead of the concrete schema representation
- Place to put aspects that may not appear in a render target
	- XML vs JSON difference, things like cardinality, element order, parent types, XML schema data types
- Doesn't force people to use XML Schema when their endgame is JSON
- Component names
	- How should we model names well?
	- We have the pieces, object, represetnation, qualifiers etc.
	- each may be multiple terms
	- We pack them into long concatenations, which loses all the info
	- Which words are with which terms, and which are modifiers?
	- Allows for different naming schemes for different render targets, plus
		- Java code
		- Documentation, diagrams
	- **This could be a later stage**
- Can do more than what XML Schema does, XSD not a limitation
- Can facilitate reuse of artifacts
	- Simpler artifacts
	- Lower bar to entry
- Renders that are:
	- Simpler
	- Are targeted to a specific dev environment
	- Could be UML, XML Schema, whatever

## Does it cause any problems

- It's new
	- Tools aren't going to support it
		- But it's just XML
		- Easier to make a tool work with it than to reverse engineer NIEM XML Schemas?
	- Complicated UML modeling tools are expensive
		- Not the NIEM Profile
		- But other forms of UML rendering
	- Cabral has NIEM-specific UML extensions for free tools
		- [cabralje/niem-tools](https://github.com/cabralje/niem-tools)
- Claims it adds an unneeded level of complexity
	- NIEM Classic, can always just use the traditional XML Schema render

>"We have a commit to support all parts of the niem livecycle using free and open source software." -- Dr. Scott

## Where are we currently?

[Metamodel Repo](https://webb.github.io/niem-metamodel)

`metamodel.xml` *is* the metamodel, as plain old XML.

Follows all the rules of NIEM conformance.

- Basic code in place for this.
- XSLT does the transformations to XML Schema
- Based on unvetted decisions

## What needs to be done?

- Modules need building out
	- XML Schema => model transform (hard)
	- model => JSON schema transform (easy)
		- what's the base element?
		- need to track top-level info
	- human readable documentation
	- content by inclusions vs by reference?
- Things not handled
	- Metadata
	- Roles?
	- Associations just use the existing NIEM class

### Rendering Targets

- XML Schema
- "Simple" XML Schema
- JSON/JSON-LD
- SQL
- CSV
- UML (via XMI)
- OWL
- [OpenAPI](https://en.wikipedia.org/wiki/OpenAPI_Specification)
- human readable documentation
	- Text
		- HTML
		- Markdown
		- RTF
		- PDF
	- Diagrams
		- DOT
		- Mermaid

## What are the roadblocks?

- Verbose and not as simple as maybe it could be?
- Needs JSON Schema help
	- JSON would be a good first win
- XMI is another early win
	- But isn't great as a format

Is the current metamodel model good enough? Is there a different way of doing things?

## Who can help?

- JSON: Dr. Scott?
- UML: Jim Cabral?

## Profiles

How do we talk about profiles of models? Is it just a smaller version of a model or is it a thing that talks about models?

What do the pieces of a subset of this model look like, including tightening cardinality?

Does this end up looking like the wantlist?

What about a list of exclusions? I want everything except A, B, and C.

## Naming (Data Element Management)

How can we keep component names in a way that maintains the meaning we put into them?

Simplest would be mmixed content, but we don't want to go there.

There some stuff in ISO-11179.

Move some of NDR stuff to the metamodel, especially the naming?


