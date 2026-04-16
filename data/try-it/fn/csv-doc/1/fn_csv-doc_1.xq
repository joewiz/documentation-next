(: csv-doc loads CSV from a URI — demo with csv-to-arrays instead :)
let $csv := "name,age
Alice,25
Bob,30"
return
    csv-to-arrays($csv)