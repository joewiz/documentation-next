let $array := ["x", "y", "z"]
let $position := 42
let $member := (1, "two", <three/>)
return
    array:put($array, $position, $member)