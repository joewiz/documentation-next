import module namespace bin = "http://expath.org/ns/binary";

(: Unpack float with byte order :)
let $packed := bin:pack-float(1.5, "most-significant-first")
return bin:unpack-float($packed, 0, "most-significant-first")
