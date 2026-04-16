let $path := "/db/apps/docs"
let $index := "example"
let $group-name := "hello"
let $allowed := true()
let $mode := "hello"
return
    sm:insert-group-ace($path, $index, $group-name, $allowed, $mode)