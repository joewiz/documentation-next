let $path := "/db/apps/docs"
let $user-name := "hello"
let $allowed := true()
let $mode := "hello"
return
    sm:add-user-ace($path, $user-name, $allowed, $mode)