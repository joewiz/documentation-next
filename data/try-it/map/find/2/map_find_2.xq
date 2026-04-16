let $input := (1, "two", <three/>)
let $key := "foo"
return
    map:find($input, $key)