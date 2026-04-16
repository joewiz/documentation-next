import module namespace bin = "http://expath.org/ns/binary";

(: Pack a double-precision float into binary :)
xs:hexBinary(bin:pack-double(3.14))
