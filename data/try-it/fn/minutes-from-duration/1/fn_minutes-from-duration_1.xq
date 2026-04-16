let $value := xs:dayTimeDuration("P1DT2H")
return
    minutes-from-duration($value)