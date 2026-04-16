let $path := "/db/apps/docs"
let $index := "example"
let $user-name := "hello"
let $allowed := true()
let $mode := "hello"
return
    sm:insert-user-ace($path, $index, $user-name, $allowed, $mode)