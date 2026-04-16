let $value := xs:time("14:30:00")
let $timezone := xs:dayTimeDuration("PT1H30M")
return
    adjust-time-to-timezone($value, $timezone)