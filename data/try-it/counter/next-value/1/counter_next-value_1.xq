(: Increment a counter and get its new value :)
let $_ := counter:create("tryit-demo-counter", xs:long(0))
let $v1 := counter:next-value("tryit-demo-counter")
let $v2 := counter:next-value("tryit-demo-counter")
let $v3 := counter:next-value("tryit-demo-counter")
let $_ := counter:destroy("tryit-demo-counter")
return map {
    "first": $v1,
    "second": $v2,
    "third": $v3
}
