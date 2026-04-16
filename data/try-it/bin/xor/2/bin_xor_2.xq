import module namespace bin = "http://expath.org/ns/binary";

(: Bitwise XOR of two binary values :)
let $a := bin:hex("FFFF")
let $b := bin:hex("0F0F")
return xs:hexBinary(bin:xor($a, $b))
