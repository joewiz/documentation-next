import module namespace bin = "http://expath.org/ns/binary";

(: Convert a binary (base-2) string to binary data :)
let $data := bin:bin("0100100001101001")
return xs:hexBinary($data)
