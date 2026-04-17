(: Find cities by field equality — match on country field :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//range:field-eq("city-country", "France")
return
  $city/name || " (" || $city/@code || ")"
