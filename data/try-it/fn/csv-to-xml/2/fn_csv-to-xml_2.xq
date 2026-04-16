let $csv := "hello"
let $options := map { "a": 1, "b": 2 }
return
    csv-to-xml($csv, $options)