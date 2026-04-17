(: Find cities founded in or before a given year :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:le(@founded, 1000)]
return
  $city/name || " (founded " || $city/@founded || ")"
