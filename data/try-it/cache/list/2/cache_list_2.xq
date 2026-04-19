(: List values for specific keys, or all values if no keys given :)
let $_ := cache:create("tryit-demo", map { "maximumSize": 10 })
let $_ := cache:put("tryit-demo", "x", 10)
let $_ := cache:put("tryit-demo", "y", 20)
let $_ := cache:put("tryit-demo", "z", 30)
let $selected := cache:list("tryit-demo", ("x", "z"))
let $all := cache:list("tryit-demo", ())
let $_ := cache:destroy("tryit-demo")
return map {
    "selected-x-z": $selected,
    "all": $all
}
