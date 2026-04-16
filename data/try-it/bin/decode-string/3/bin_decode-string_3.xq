import module namespace bin = "http://expath.org/ns/binary";

(: Decode a portion of binary to string :)
let $binary := bin:hex("48656C6C6F20576F726C64")
return bin:decode-string($binary, "UTF-8", 6, 5)
