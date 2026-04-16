let $value := xs:dayTimeDuration("P1DT2H")
return
    months-from-duration($value)