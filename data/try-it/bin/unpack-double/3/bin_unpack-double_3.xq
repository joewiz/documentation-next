import module namespace bin = "http://expath.org/ns/binary";

(: Unpack double with byte order :)
let $packed := bin:pack-double(2.718, "most-significant-first")
return bin:unpack-double($packed, 0, "most-significant-first")
