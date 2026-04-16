import module namespace bin = "http://expath.org/ns/binary";

(: Extract a fixed-length portion of binary data :)
let $data := bin:encode-string("Hello World")
let $part := bin:part($data, 0, 5)
return bin:decode-string($part, "UTF-8")
