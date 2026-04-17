(: Find cities whose name field starts with a prefix :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-starts-with("city-name", "B")
return
  $city/name || " (" || $city/country || ")"
