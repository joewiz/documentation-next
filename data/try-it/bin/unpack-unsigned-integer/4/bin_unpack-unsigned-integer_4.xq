import module namespace bin = "http://expath.org/ns/binary";

(: Unpack unsigned integer with byte order :)
let $data := bin:hex("FFFF")
return bin:unpack-unsigned-integer($data, 0, 2, "most-significant-first")
