let $value := xs:time("14:30:00")
let $picture := "hello"
let $language := "hello"
let $calendar := "hello"
let $place := "hello"
return
    format-time($value, $picture, $language, $calendar, $place)