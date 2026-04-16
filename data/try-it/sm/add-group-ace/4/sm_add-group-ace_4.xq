let $path := "/db/apps/docs"
let $group-name := "hello"
let $allowed := true()
let $mode := "hello"
return
    sm:add-group-ace($path, $group-name, $allowed, $mode)