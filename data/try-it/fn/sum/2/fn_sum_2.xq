(: sum#2 with a zero value for empty sequences :)
let $values := ()
let $zero := 0
return
    sum($values, $zero)