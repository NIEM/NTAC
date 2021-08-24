# Message Spec Rules and Conventions

- Mike Hulme has some ideas with which to start

Mike Hulme:

- Won't be a "spec." Will be something simpler. Should be faster to turn around. ~6 months
- It's really more targeted to tool folks to create an IEPD, not for normal folks making an IEPD.
- Need a better name, NIEM Message Spec Guidelines
- If you follow the convention, you don't have to say that
- Minimize reliance on tools that aren't widely available
	- Even XML is dicey
- Jim Cabral: Use MUST instead of SHALL, SHALL confuses folks
- Dr. Scott: 3 representation
	- rep of the document
	- rep of the spec artifacts itself
	- rep of model that tells yopu what the model means
- Dr. Scott: UML is a way to make a NIEM model instance, but it doesn't define the instance
- _Is the model instance required?_
- Christina: You can still write the model instance in JSON or whatever. Require it, but it could be a different format.
- Source code to compiled analogy
- Can you have a message spec without a model, just a JSON Schema doc?
- Just sample JsON instances?
- Dr. Scott: Different conform targets for folks who don't have a model?

### Manifests and Metadata

- Dr. Scott: a message spec ought to tell you what messages it specifies
- examples

#todo Create an outline

## Related Documentation from Christina

**Will link to issues for each.**

- Profile with common business rules 
- Refactor the NDR, splitting out metamodel, adding XML (and JSON?) supplements 
- Unit tests for the Schematron rules, as well as other implementations
- Make NDR rules more explanatory, with fewer references to follow 
	- "Say what it is, not where to find it."
