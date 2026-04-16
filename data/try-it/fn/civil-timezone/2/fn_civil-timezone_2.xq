let $value := current-dateTime()
let $place := "America/New_York"
return
    civil-timezone($value, $place)