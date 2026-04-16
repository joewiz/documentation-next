let $date := xs:date("2025-06-15")
let $time := xs:time("14:30:00")
return
    dateTime($date, $time)