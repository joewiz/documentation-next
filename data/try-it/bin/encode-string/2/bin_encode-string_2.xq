import module namespace bin = "http://expath.org/ns/binary";

(: Encode a string as binary using a specific encoding :)
let $data := bin:encode-string("Héllo", "ISO-8859-1")
return xs:hexBinary($data)
