let $value := xs:dayTimeDuration("P1DT2H")
return
    hours-from-duration($value)