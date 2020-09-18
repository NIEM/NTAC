
The XML name is the traditional NIEM XML name.

The XML name isn't good for going backwards:
- We don't know what it really means.
- We can't easily map XML names to dictionary meanings of words.
- We can't distinguish between words and mulit-word terms.
- We can't distinguish between root terms and modifier terms.

We don't have an especially good vocabulary for parts of component names. We don't have words that distinguish between:
- a property term with its qualifier and its root term
- just the property term's root term (currently titled "property term").

Parts of a name:

- name: subject, property, representation: composite term
- composite term: qualifier*, root: term
- term: string;

```
name [label="\N\l|<s>subject\l|<p>property\l|<r>representation\l"];
name:s:e -> "composite term":top:w;
name:p:e -> "composite term":top:w;
name:r:e -> "composite term":top:w;

"composite term" [label="<top>\N\l|<q>qualifier [0-n]\l|<r>root\l"];
"composite term":q:e -> term:top:w;
"composite term":r:e -> term:top:w;

term [label="<top>\N: string\l"];
```




