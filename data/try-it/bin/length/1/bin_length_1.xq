import module namespace bin = "http://expath.org/ns/binary";

(: Get the length of binary data in octets :)
let $data := bin:encode-string("Hello")
return bin:length($data) || " octets"
