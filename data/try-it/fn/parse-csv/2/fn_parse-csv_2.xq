let $csv := "hello"
let $options := map { "a": 1, "b": 2 }
return
    parse-csv($csv, $options)