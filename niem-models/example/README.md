
A simple data model example showing use of the NIEM Metamodel, converted into NIEM-conformant XML Schema.

The example is an insurance claim, including a damaged vehicle, with the vehicle's damage amount.

# Files:

- [extension.xml](extension.xml): An instance of the NIEM Metamodel, defining an extension namespace for an exchange.
- [generated/xsd/claim.xsd](generated/xsd/claim.xsd): A conformant reference schema for the extension namespace.
- [claim.xml](claim.xml): A sample instance, containing a single insurance claim.
- [niem](niem): A NIEM subset supporting the exchange.


