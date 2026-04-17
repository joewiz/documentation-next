(: Remove an entire sort index by name :)
let $items := doc("/db/apps/docs/data/try-it/range/data/cities.xml")//city
let $values := for $item in $items return $item/name/string()
let $_ := sort:create-index("demo-remove", $items, $values, ())
let $before := sort:has-index("demo-remove")
let $_ := sort:remove-index("demo-remove")
let $after := sort:has-index("demo-remove")
return
  "Index existed: " || $before || " → after remove: " || $after
