(: Find cities by exact name match using the range index :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:eq(name, "Paris")]
return
  $city/name || " (" || $city/country || ")"
