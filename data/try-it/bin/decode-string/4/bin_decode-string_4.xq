import module namespace bin = "http://expath.org/ns/binary";

(: Decode binary with offset and length :)
let $binary := bin:encode-string("Hello World!")
return bin:decode-string($binary, "UTF-8", 0, 5)
