(: Create a persistent counter with a custom initial value :)
let $value := counter:create("tryit-demo-counter", xs:long(100))
let $_ := counter:destroy("tryit-demo-counter")
return "Created counter with initial value: " || $value
