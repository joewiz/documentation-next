let $value := "red green blue"
let $token := "green"
let $collation := "http://www.w3.org/2013/collation/UCA"
return
    contains-token($value, $token, $collation)