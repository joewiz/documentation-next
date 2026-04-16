let $value := xs:date("2025-06-15")
let $timezone := xs:dayTimeDuration("PT1H30M")
return
    adjust-date-to-timezone($value, $timezone)