(: Find cities whose name starts with a given prefix :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:starts-with(name, "New")]
return
  $city/name || " (" || $city/@code || ")"
