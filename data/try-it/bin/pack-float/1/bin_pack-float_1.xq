import module namespace bin = "http://expath.org/ns/binary";

(: Pack a single-precision float into binary :)
xs:hexBinary(bin:pack-float(3.14))
