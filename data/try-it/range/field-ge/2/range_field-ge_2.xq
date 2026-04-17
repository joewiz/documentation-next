(: Find cities whose name field is greater than or equal to a value :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-ge("city-name", "Sydney")
return
  $city/name || " (" || $city/country || ")"
