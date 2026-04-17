(: Find cities whose name field is less than a value (string comparison) :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-lt("city-name", "London")
return
  $city/name || " (" || $city/country || ")"
