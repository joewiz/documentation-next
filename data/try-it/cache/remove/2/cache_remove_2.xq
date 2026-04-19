(: Remove an entry from a cache — returns the previous value :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-demo", "temp", "will be removed")
let $removed := cache:remove("tryit-demo", "temp")
let $gone := cache:get("tryit-demo", "temp")
let $_ := cache:destroy("tryit-demo")
return map {
    "removed-value": $removed,
    "after-removal": $gone
}
