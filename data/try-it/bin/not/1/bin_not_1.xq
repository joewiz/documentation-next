import module namespace bin = "http://expath.org/ns/binary";

(: Bitwise NOT (complement) of binary data :)
let $data := bin:hex("0F0F")
return xs:hexBinary(bin:not($data))
