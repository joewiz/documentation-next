(: Find cities whose name field is less than or equal to a value :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-le("city-name", "London")
return
  $city/name || " (" || $city/country || ")"
