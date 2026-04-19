(: Create a persistent counter with default initial value :)
let $value := counter:create("tryit-demo-counter")
let $_ := counter:destroy("tryit-demo-counter")
return "Created counter with initial value: " || $value
