(: Find cities whose code matches a regular expression :)
(: Regex syntax is Lucene's RegExp, not full PCRE :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:matches(@code, "[A-Z]{3}")]
return
  $city/@code/string() || " → " || $city/name
