let $input := (10, 30, 20, 10)
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    lowest($input, $collation)