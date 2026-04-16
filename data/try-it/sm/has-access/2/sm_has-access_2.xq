let $path := "/db/apps/docs"
let $mode := "hello"
return
    sm:has-access($path, $mode)