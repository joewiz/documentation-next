(: Find cities whose name ends with a given suffix :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:ends-with(name, "on")]
return
  $city/name || " (" || $city/@code || ")"
