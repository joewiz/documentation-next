(: Destroy a persistent counter :)
let $_ := counter:create("tryit-destroy-demo")
let $removed := counter:destroy("tryit-destroy-demo")
let $not-found := counter:destroy("tryit-destroy-demo")
return map {
    "first-destroy": $removed,
    "second-destroy-already-gone": $not-found
}
