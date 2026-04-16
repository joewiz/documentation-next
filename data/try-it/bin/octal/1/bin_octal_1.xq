import module namespace bin = "http://expath.org/ns/binary";

(: Convert an octal string to binary data :)
let $data := bin:octal("377")
return xs:hexBinary($data)
