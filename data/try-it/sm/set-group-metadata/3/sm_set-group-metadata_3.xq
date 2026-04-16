let $group-name := "hello"
let $attribute := "/db/apps/docs"
let $value := "hello"
return
    sm:set-group-metadata($group-name, $attribute, $value)