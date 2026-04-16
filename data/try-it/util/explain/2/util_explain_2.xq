let $query := "hello"
let $module-load-path := "hello"
return
    util:explain($query, $module-load-path)