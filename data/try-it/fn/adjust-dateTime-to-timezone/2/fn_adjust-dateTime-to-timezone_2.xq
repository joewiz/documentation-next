let $value := current-dateTime()
let $timezone := xs:dayTimeDuration("PT1H30M")
return
    adjust-dateTime-to-timezone($value, $timezone)