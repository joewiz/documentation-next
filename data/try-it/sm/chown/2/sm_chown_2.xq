let $path := "/db/apps/docs"
let $owner := "hello"
return
    sm:chown($path, $owner)