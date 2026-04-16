import module namespace bin = "http://expath.org/ns/binary";

(: Unpack an unsigned integer from binary :)
let $data := bin:hex("FF")
return bin:unpack-unsigned-integer($data, 0, 1)
