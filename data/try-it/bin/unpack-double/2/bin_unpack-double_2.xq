import module namespace bin = "http://expath.org/ns/binary";

(: Unpack a double from binary data :)
let $packed := bin:pack-double(3.14)
return bin:unpack-double($packed, 0)
