let $csv := "name,age,city
Alice,25,NYC
Bob,30,LA"
let $options := map { "header": true() }
return
    csv-to-xml($csv, $options)