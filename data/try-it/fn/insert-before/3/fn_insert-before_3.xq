let $input := (1, "two", <three/>)
let $position := 42
let $insert := (1, "two", <three/>)
return
    insert-before($input, $position, $insert)