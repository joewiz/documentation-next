import module namespace bin = "http://expath.org/ns/binary";

(: Find the position of a byte sequence within binary data :)
let $data := bin:encode-string("Hello World Hello")
let $search := bin:encode-string("World")
return bin:find($data, 0, $search)
