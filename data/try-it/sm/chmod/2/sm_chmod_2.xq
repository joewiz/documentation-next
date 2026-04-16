let $path := "/db/apps/docs"
let $mode := "hello"
return
    sm:chmod($path, $mode)