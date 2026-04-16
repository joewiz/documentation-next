let $items-1 := (1, "two", <three/>)
let $items-2 := (1, "two", <three/>)
let $options := "hello"
return
    deep-equal($items-1, $items-2, $options)