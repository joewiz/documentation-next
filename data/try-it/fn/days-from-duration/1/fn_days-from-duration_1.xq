let $value := xs:dayTimeDuration("P1DT2H")
return
    days-from-duration($value)