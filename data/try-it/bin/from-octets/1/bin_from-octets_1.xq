import module namespace bin = "http://expath.org/ns/binary";

(: Create binary data from a sequence of octets :)
let $octets := (72, 101, 108, 108, 111)
let $data := bin:from-octets($octets)
return bin:decode-string($data, "UTF-8")
