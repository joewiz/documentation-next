import module namespace bin = "http://expath.org/ns/binary";

(: Pack double with byte order :)
(
    "Big-endian: " || xs:hexBinary(bin:pack-double(3.14, "most-significant-first")),
    "Little-endian: " || xs:hexBinary(bin:pack-double(3.14, "least-significant-first"))
)
