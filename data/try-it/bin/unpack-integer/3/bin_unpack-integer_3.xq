import module namespace bin = "http://expath.org/ns/binary";

(: Unpack a signed integer from binary data :)
let $data := bin:hex("00FF")
return bin:unpack-integer($data, 0, 2)
