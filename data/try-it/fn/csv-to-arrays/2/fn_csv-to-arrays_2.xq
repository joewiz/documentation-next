let $csv := "Alice;25
Bob;30"
let $options := map { "separator": ";" }
return
    csv-to-arrays($csv, $options)