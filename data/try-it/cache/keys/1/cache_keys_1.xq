(: List all keys in a cache :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-demo", "a", 1)
let $_ := cache:put("tryit-demo", "b", 2)
let $_ := cache:put("tryit-demo", "c", 3)
let $keys := cache:keys("tryit-demo")
let $_ := cache:destroy("tryit-demo")
return $keys
