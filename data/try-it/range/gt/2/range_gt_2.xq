(: Find cities with population greater than a threshold :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:gt(population, 5000000)]
order by xs:integer($city/population) descending
return
  $city/name || ": " || format-number(xs:integer($city/population), "#,###")
