(: Find cities whose name field is greater than a value (string comparison) :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-gt("city-name", "Paris")
return
  $city/name || " (" || $city/country || ")"
