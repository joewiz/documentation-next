let $path := "/db/apps/docs"
let $index := "example"
let $allowed := true()
let $mode := "hello"
return
    sm:modify-ace($path, $index, $allowed, $mode)