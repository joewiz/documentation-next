(: Clear all entries from all caches :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-demo", "key", "value")
let $_ := cache:clear()
let $after := cache:get("tryit-demo", "key")
let $_ := cache:destroy("tryit-demo")
return map {
    "after-clear": $after,
    "description": "cache:clear#0 clears all entries from all caches"
}
