import module namespace bin = "http://expath.org/ns/binary";

(: Unpack integer with byte order :)
let $data := bin:hex("0100")
return (
    "Big-endian: " || bin:unpack-integer($data, 0, 2, "most-significant-first"),
    "Little-endian: " || bin:unpack-integer($data, 0, 2, "least-significant-first")
)
