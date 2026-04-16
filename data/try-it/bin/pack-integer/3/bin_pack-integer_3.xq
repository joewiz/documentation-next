import module namespace bin = "http://expath.org/ns/binary";

(: Pack integer with specified byte order :)
(
    "Big-endian: " || xs:hexBinary(bin:pack-integer(256, 2, "most-significant-first")),
    "Little-endian: " || xs:hexBinary(bin:pack-integer(256, 2, "least-significant-first"))
)
