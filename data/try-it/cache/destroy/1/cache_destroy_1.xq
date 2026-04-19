(: Destroy a cache entirely :)
let $_ := cache:create("tryit-destroy-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-destroy-demo", "key", "value")
let $_ := cache:destroy("tryit-destroy-demo")
return "Cache 'tryit-destroy-demo' destroyed — it no longer appears in cache:names()"
