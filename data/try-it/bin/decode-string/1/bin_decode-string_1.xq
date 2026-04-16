import module namespace bin = "http://expath.org/ns/binary";

(: Decode binary to string using default UTF-8 :)
let $binary := bin:hex("48656C6C6F")
return bin:decode-string($binary, "UTF-8")
