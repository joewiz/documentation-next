(: Create a pre-ordered sort index from explicit values :)
(: Each value corresponds to one node; used with 'order by sort:index(...)' :)
let $items := doc("/db/apps/docs/data/try-it/range/data/cities.xml")//city
let $values := for $item in $items return $item/name/string()
let $_ := sort:create-index("demo-cities", $items, $values,
  <options order="ascending" empty="least"/>)
let $sorted :=
  for $city in $items
  order by sort:index("demo-cities", $city)
  return $city/name/string()
let $_ := sort:remove-index("demo-cities")
return
  $sorted
