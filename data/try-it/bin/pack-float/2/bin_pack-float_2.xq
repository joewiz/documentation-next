import module namespace bin = "http://expath.org/ns/binary";

(: Pack float with byte order :)
xs:hexBinary(bin:pack-float(3.14, "most-significant-first"))
