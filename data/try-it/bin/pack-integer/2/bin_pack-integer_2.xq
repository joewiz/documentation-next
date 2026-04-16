import module namespace bin = "http://expath.org/ns/binary";

(: Pack an integer into binary with specified byte count :)
(
    "255 as 1 byte: " || xs:hexBinary(bin:pack-integer(255, 1)),
    "255 as 2 bytes: " || xs:hexBinary(bin:pack-integer(255, 2)),
    "65535 as 2 bytes: " || xs:hexBinary(bin:pack-integer(65535, 2))
)
