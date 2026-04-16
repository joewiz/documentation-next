let $path := "/db/apps/docs"
let $index := "example"
return
    sm:remove-ace($path, $index)