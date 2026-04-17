(: Find cities whose name field ends with a suffix :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-ends-with("city-name", "is")
return
  $city/name || " (" || $city/country || ")"
