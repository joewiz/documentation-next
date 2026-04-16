let $input := (10, 30, 20, 30)
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    highest($input, $collation)