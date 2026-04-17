(: Find cities whose country is not a given value :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:ne(country, "United States")]
return
  $city/name || " (" || $city/country || ")"
