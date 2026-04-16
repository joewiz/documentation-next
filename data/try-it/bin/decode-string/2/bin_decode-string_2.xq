import module namespace bin = "http://expath.org/ns/binary";

(: Decode binary to string with encoding :)
let $binary := bin:hex("48E96C6C6F")
return bin:decode-string($binary, "ISO-8859-1")
