import module namespace bin = "http://expath.org/ns/binary";

(: Unpack a float from binary :)
let $packed := bin:pack-float(3.14)
return bin:unpack-float($packed, 0)
