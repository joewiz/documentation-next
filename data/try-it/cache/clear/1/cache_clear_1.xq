(: Clear all entries from a specific named cache :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-demo", "key", "value")
let $_ := cache:clear("tryit-demo")
let $after := cache:get("tryit-demo", "key")
let $_ := cache:destroy("tryit-demo")
return map {
    "after-clear": $after,
    "description": "cache:clear#1 clears entries from the named cache only"
}
