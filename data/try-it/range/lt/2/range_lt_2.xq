(: Find cities with population less than a threshold :)
let $data := collection("/db/apps/docs/data/try-it/range/data")
for $city in $data//city[range:lt(population, 5000000)]
order by xs:integer($city/population)
return
  $city/name || ": " || format-number(xs:integer($city/population), "#,###")
