(: Perform pending cache maintenance (eviction) on the current thread :)
let $_ := cache:create("tryit-demo", map {
    "maximumSize": 2,
    "expireAfterAccess": 1
})
let $_ := cache:put("tryit-demo", "a", 1)
let $_ := cache:put("tryit-demo", "b", 2)
let $_ := cache:put("tryit-demo", "c", 3)
let $_ := cache:cleanup("tryit-demo")
let $keys := cache:keys("tryit-demo")
let $_ := cache:destroy("tryit-demo")
return map {
    "keys-after-cleanup": $keys,
    "description": "Eviction runs asynchronously; cleanup forces it on the current thread"
}
