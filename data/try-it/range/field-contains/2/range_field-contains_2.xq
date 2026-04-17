(: Find cities whose name field contains a substring :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-contains("city-name", "yo")
return
  $city/name || " (" || $city/country || ")"
