(: Put a value into a cache and retrieve the previous value for that key :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $prev1 := cache:put("tryit-demo", "greeting", "hello")
let $prev2 := cache:put("tryit-demo", "greeting", "bonjour")
let $_ := cache:destroy("tryit-demo")
return map {
    "first-put-previous": $prev1,
    "second-put-previous": $prev2
}
