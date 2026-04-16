let $value := xs:dayTimeDuration("P1DT2H")
return
    seconds-from-duration($value)