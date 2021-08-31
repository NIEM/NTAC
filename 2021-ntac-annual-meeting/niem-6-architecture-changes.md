# NIEM 6 Architecture Changes

**All text attributed to individuals is paraphrased.**

## So many attributes!
- Everything in NIEM is a complex object with `simpleObjectAttributeGroup`
- Does everything need to have all the attributes? (See NTAC/2021 NTAC Face-2-Face/Deep Thoughts with Dr. Scott#Email)

## Lead Developer Ideas

**These will link to individual issues for each.**

- Make adapter types consistent with the rest of the model (Issue #30)
- Add Adapter Representation term for consistency 
- Make Representation vs Abstracts consistent 
	- Representations for things that are actual different representations, not just code and text versions
- Replace `RoleOf` 
	- Specialize instead of role
	- User Representation for multiple role types, e.g. Person and Organization (only ~25% of them)
	- Reserve referencing for cases that actually need it, e.g. an object playing multiple roles
	- **Make the usual use case easy; make the harder use cases no harder**
- Simplify Metadata 
	- Kill off `structures:relationshipMetadata`
	- Replace the metadata references with an augmentation point added to `structures:ObjectType`
	- Add metadata meant to apply to one thing inline in that one thing
	- Use normal referencing for tougher combinations
	- **Make the usual use case easy; make the harder use cases no harder**
- Eliminate the complex wrapper for codes 
	- Lose the simple type
		- lose the benefits of code extensibility and aggregation (both via unions)
		- lose attribute reuse
	- Just start with the complex type
- Call `conformanceTarget` something less obtuse 
- Don't mark subsets as reference specs, because they ain't 
- No elements and attributes with the same name 
	- Some technologies are going to not be case sensitive
- Require definitions for patterns, to make them easier to understand 
- Disallow `http:release.niem.gov/niem` for exchange target namespaces 
	- Folks copy/paste this by accident
	- URIs are supposed to be things you own via DNS anyway
- Fix a variety of utility schema things 
- Make niem-xs type names conformant 
- Decouple some concepts from XML Schema
	- Decouple NIEM and XML Schema simple types 
	- Decouple NIEM from other XML Schema-specific constructs 
		- Let folks simplify their XML like we let them simplify their JSON
		- Implement constraint simplifications _in_ the generated subset
			- Collapse type hierarchies
				- Discrete cardinality
			- Inline substitution groups
- Handle duplicate enums 
	- There are duplicate enums in the model
	- XML Schema doesn't care
	- Other things do
- Look at using XML Schema 1.1 for NIEM 6? 
	- Why did we reject this for NIEM 5?

## Dr. Scott Suggestions

### Get rid of sequenceID

Replace `sequenceID` with an appinfo element that marks it as sorted, for multiple elements.

It's an XML kludge that doesn't translate well to other things.

Dr. Scott: Could maybe in the future use JSON-LD instead of RDF?

_Are there environments in which the ordering isn't maintained?_

Mike Hulme: Can just be a business rule, too. Can maybe just get rid of the whole concept?

JSON Type Definition RFC 8923? Translates JSON Schema to all sort of other things.

Model Instance -> JSON TypeDef -> All sorts of stuff.

#### JSON-LD as a replacement for RDF

_No notes on this._

### Down with Attributes

Change all the attributes containing semantic data into elements, leaving just the infrastructure support stuff.

- Makes the RDF cleaner.
- More consistent.
- Removes arguments for others to use attributes.

Christina: Some attributes, like text string stuff. Would require text elements to have a inner element.

Dr. Scott: Choices

- kill the concepts
- do as metadata
- don't do this

### Allow pure simple types

Christina: ICM couldn't then point to simple data.

_That probably kills it._

#resolved This is probably dead.

### Allow simply external type

Killed by above.

### Rules for namespace URIs

Christina already thought of most of this.

Rules about these to allow them to be easily parsed, but disallowing "release.niem.gov" already does it.

No hash marks in the URI is already a rule in the IEPD spec.

#todo Add it to the NDR, and update how to qualify the URI section.


### Version standard

#todo dropped

### Things to talk about with the NIEM Model

Can we combine JSON schemas? Dr. Scott couldn't, but Christina has had success.

Christina: Need to add the extra stuff like `choice` to the metamodel to support community content.

Dr. Scott: Is there more than just like a sub group?

Christina, Jim Cabral, Mike Hulme all say yes.

Christina: Can add keywords to JSON Schema.

## metadata vs relationshipMetadata

#resolved Kill off `relationshipMetadata`. Let user's implement if they really need that.
