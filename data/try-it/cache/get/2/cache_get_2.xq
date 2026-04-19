(: Get a value from a cache by key :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-demo", "color", "blue")
let $value := cache:get("tryit-demo", "color")
let $_ := cache:destroy("tryit-demo")
return $value
