(: Check whether a named sort index exists :)
let $items := doc("/db/apps/docs/data/try-it/range/data/cities.xml")//city
let $values := for $item in $items return $item/name/string()
let $_ := sort:create-index("demo-check", $items, $values, ())
let $exists-before := sort:has-index("demo-check")
let $_ := sort:remove-index("demo-check")
let $exists-after := sort:has-index("demo-check")
return
  <result>
    <before-remove>{$exists-before}</before-remove>
    <after-remove>{$exists-after}</after-remove>
  </result>
