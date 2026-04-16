import module namespace bin = "http://expath.org/ns/binary";

(: Convert binary data to a sequence of octets (integers 0-255) :)
let $data := bin:encode-string("ABC")
return bin:to-octets($data)
