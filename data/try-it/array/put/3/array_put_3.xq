let $array := ["a", "b", "c"]
let $position := 2
let $member := "REPLACED"
return
    array:put($array, $position, $member)