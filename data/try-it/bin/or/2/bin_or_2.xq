import module namespace bin = "http://expath.org/ns/binary";

(: Bitwise OR of two binary values :)
let $a := bin:hex("FF00")
let $b := bin:hex("00FF")
return xs:hexBinary(bin:or($a, $b))
