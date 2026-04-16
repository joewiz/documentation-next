import module namespace bin = "http://expath.org/ns/binary";

(: Convert hex string to binary :)
let $data := bin:hex("48656C6C6F")
return bin:decode-string($data, "UTF-8")
