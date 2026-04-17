(: Find cities founded in or after a given year :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:ge(@founded, 1500)]
return
  $city/name || " (founded " || $city/@founded || ")"
