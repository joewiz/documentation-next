(: Create a sort index using a callback function to extract sort keys :)
let $items := doc("/db/apps/docs/data/try-it/range/data/cities.xml")//city
let $_ := sort:create-index-callback(
  "demo-pop",
  $items,
  function($node) { xs:integer($node/population) },
  <options order="descending" empty="least"/>
)
let $sorted :=
  for $city in $items
  order by sort:index("demo-pop", $city)
  return $city/name || ": " || format-number(xs:integer($city/population), "#,###")
let $_ := sort:remove-index("demo-pop")
return
  $sorted
