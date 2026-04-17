(: Look up a node's position in a sort index :)
(: Returns an integer > 0 corresponding to the node's sorted position :)
let $items := doc("/db/apps/docs/data/try-it/range/data/cities.xml")//city
let $values := for $item in $items return $item/name/string()
let $_ := sort:create-index("demo-lookup", $items, $values,
  <options order="ascending" empty="least"/>)
let $result :=
  for $city in $items
  return
    $city/name || " → position " || sort:index("demo-lookup", $city)
let $_ := sort:remove-index("demo-lookup")
return
  $result
