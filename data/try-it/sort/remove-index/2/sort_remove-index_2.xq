(: Remove sort index entries for a specific document :)
let $doc := doc("/db/apps/docs/data/try-it/range/data/cities.xml")
let $items := $doc//city
let $values := for $item in $items return $item/name/string()
let $_ := sort:create-index("demo-doc-remove", $items, $values, ())
let $before := sort:has-index("demo-doc-remove")
let $_ := sort:remove-index("demo-doc-remove", $doc/*)
let $_ := sort:remove-index("demo-doc-remove")
return
  "Index existed: " || $before || " → cleaned up"
