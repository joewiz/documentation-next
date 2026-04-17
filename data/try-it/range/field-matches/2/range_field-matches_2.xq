(: Find cities whose code field matches a regex pattern :)
(: Regex uses Lucene RegExp syntax :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-matches("city-code", "[BNP].*")
return
  $city/@code/string() || " → " || $city/name
