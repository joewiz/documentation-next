(: Find cities whose name contains a substring :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:contains(name, "er")]
return
  $city/name || " (" || $city/country || ")"
