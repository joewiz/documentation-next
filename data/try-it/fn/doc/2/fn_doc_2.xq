let $document-uri := "hello"
let $options := map { "a": 1, "b": 2 }
return
    doc($document-uri, $options)