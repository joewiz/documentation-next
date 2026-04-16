let $value := xs:dayTimeDuration("P1DT2H")
return
    years-from-duration($value)