# Metamodel

**All text attributed to individuals is paraphrased.**

- Who is the target for the metamodel itself
	- Is the metamodel just for us, e.g. GTRI and the NTAC?
	- Do we expect the community to use it directly?
	- Or do we expect the community to use transformed versions of the model, e.g. XML Schema or JSON?
	- Does the SSGT produce XML Schema and JSON
	- Or does the SSGT also produce subset of the metamodel
- Are we changing too much in terms of terminology?
	- How will the community handle a switch to OWL or RDF terminology?
- Are we looking for a platform-neutral NIEM model, or a generic framework inside of which we can build models like a platform-neutral NIEM model?
- Update on Vamsi Kondannagari's Metamodel Primer review
- Model format as canonical form, when can we stop using XML Schema?
- Gap analysis (See below What's Outstanding)
- Tool status
	- NIEM Model -> NIEM XML Schema Model (easier)
	- NIEM Model -> JSON (harder)
		- Dr. Scott simplifications would reset my efforts here, not a bad thing
	- NIEM Model -> RDF (idk)
		- RDF/XML 
- Tool demos?
- Dr. Scott 
	- NTAC/2021 NTAC Face-2-Face/Deep Thoughts with Dr. Scott
	- Potential Simplifications to the Metamodel design

___

## Jim Cabral Comments from last year:

### simple obj attribute groups

Aren't in the metamodel. Prevents round-tripping.

Is round-tripping a requirement? Not, but it's cool, so add it if we can?

### extension vs exchange

Do we render one metamodel per message or per IEPD?

### substitution groups

Are substitution groups supported?

Where do the sub group members go? Where do they get defined?
"convention over configuration"

Maybe just a convention that the first one is the root one.

Can we have metamodel parts in different files?

Or one huge XML file?

Doesn't deal with enumerations well. They explode. **Review Jim Cabral uploads**

___

## What's Outstanding (via Webb Roberts)

- How to handle something like a wantlist.
	- Easy to do a complete model, but a subset, or profile is harder.
- Identify when we add additional things as overlaps
	- As we add targeted output
	- Ontology, OWL or RDFS or Shackle? These will put demands on the content of the metamodel. Might add additional properties and characteristics. Where do they go and how are they represented in a neutral format?
- Code lists are just there as enumerations, but doesn't reflect the entire code list spec
	- The Genericode stuff is held at a distance.
	- Code List Spec sets up its own framework. If you're doing Genericode, these are the things reflected here. How do they map.
		- Genericode is just mapped at the end, so changes should be easy to add.
		- Webb hates Genericode.
		- They never got it standardized, just committee spec at OASIS.
		- Jim Cabral: The Genericode folks are just XML Schema now.
- Business rules, schematron, constraints, whatever
	- We had something for Schematron and XSD, but was just a draft.
- What do we need to still do to generate the reference schemas?
	- That's the base level of done, but just replicates what we have now
	- Add JSON output?
	- Gaps:
		- Look at the language code that's now required for 5.0, not covered (It's a brown M&M.)
		- Probably others
		- Wantlists, how much goes in, what's the getlist (wantlist resolved), what's the difference between a model and a wantlist
		- Other representations will then feed back?
		- Need to be comfortable with partial schemas, outputs that don't cover _everything_ in the model. These aren't lossless conversions.
		- Need to get comfortable with partial metamodels. JSON Schema or RDF may have more content than the XSDs. Or more than the model instance.
		- Lossy lossy lossy. But these losses will tell us what features need to be added to the metamodel.
