let $value := xs:time("14:30:00")
let $picture := "hello"
return
    format-time($value, $picture)