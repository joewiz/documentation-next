import module namespace bin = "http://expath.org/ns/binary";

(: Bitwise AND of two binary values :)
let $a := bin:hex("FF0F")
let $b := bin:hex("0FF0")
return xs:hexBinary(bin:and($a, $b))
