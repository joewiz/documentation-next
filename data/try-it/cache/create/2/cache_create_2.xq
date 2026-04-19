(: Create a named cache with configuration :)
let $created := cache:create("tryit-demo", map {
    "maximumSize": 100,
    "expireAfterAccess": 60000
})
let $_ := cache:destroy("tryit-demo")
return "Cache created: " || $created
