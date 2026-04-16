import module namespace bin = "http://expath.org/ns/binary";

(: Extract a subsequence of binary data starting at offset :)
let $data := bin:encode-string("Hello World")
let $part := bin:part($data, 6)
return bin:decode-string($part, "UTF-8")
