let $items-1 := (1, "two", <three/>)
let $items-2 := (1, "two", <three/>)
return
    deep-equal($items-1, $items-2)