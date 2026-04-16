import module namespace bin = "http://expath.org/ns/binary";

(: Encode a string as binary using default UTF-8 :)
let $data := bin:encode-string("Hello, World!")
return xs:hexBinary($data)
