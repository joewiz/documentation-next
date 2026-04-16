let $module-uri := "hello"
let $options := map { "a": 1, "b": 2 }
return
    load-xquery-module($module-uri, $options)