(: csv-doc#2 loads CSV from a URI with options :)
let $csv := "name,age
Alice,25
Bob,30"
return csv-to-arrays($csv)