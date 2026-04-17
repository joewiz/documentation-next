(: Find cities where the country field is not a given value :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-ne("city-country", "United States")
return
  $city/name || " (" || $city/country || ")"
