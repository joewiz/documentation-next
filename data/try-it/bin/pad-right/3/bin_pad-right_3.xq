import module namespace bin = "http://expath.org/ns/binary";

(: Pad binary data on the right with a specific byte :)
let $data := bin:hex("FF")
let $padded := bin:pad-right($data, 4, 170)
return xs:hexBinary($padded)
