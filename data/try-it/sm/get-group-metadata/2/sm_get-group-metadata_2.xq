let $group-name := "hello"
let $attribute := "/db/apps/docs"
return
    sm:get-group-metadata($group-name, $attribute)