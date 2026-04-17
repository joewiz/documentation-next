(: Compare two XML nodes for equivalence :)
let $original :=
  <book>
    <title>XQuery in Action</title>
    <author>Jane Smith</author>
  </book>
let $identical :=
  <book>
    <title>XQuery in Action</title>
    <author>Jane Smith</author>
  </book>
let $modified :=
  <book>
    <title>XQuery in Action</title>
    <author>John Doe</author>
  </book>
return
  <results>
    <same-content>{xmldiff:compare($original, $identical)}</same-content>
    <different-content>{xmldiff:compare($original, $modified)}</different-content>
  </results>
