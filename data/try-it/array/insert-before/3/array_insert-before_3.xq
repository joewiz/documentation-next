let $array := ["a", "b", "c"]
let $position := 2
let $member := "NEW"
return
    array:insert-before($array, $position, $member)